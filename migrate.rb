require 'aws-sdk-s3'
require 'mysql2'

module Migrate

  def self.update_path(old_path, new_path)
    begin
      client = Mysql2::Client.new(:host => ENV['DB_HOSTNAME'], :username => ENV['DB_USERNAME'], :password => ENV['DB_PASSWORD'], :database => ENV['DB_NAME'])
      client.query("UPDATE path SET path = '#{new_path}' WHERE path='#{old_path}'")
      
    rescue Mysql2::Error => e
      puts e.errno
      puts e.error
      
    #ensure
    #  I need to close this connection
    end
  end

  def self.copy(source_bucket_name, target_bucket_name)
    
    s3 = Aws::S3::Resource.new({
        region: ENV['AWS_REGION'],
        access_key_id: ENV['AWS_ACCESS_KEY_ID'], 
        secret_access_key: ENV['AWS_SECRET_ACCESS_KEY']
      })
    buckets = s3.bucket(source_bucket_name).objects(prefix:'image/', delimiter: '/', start_after:'image/').collect(&:key)
    
    s3 = Aws::S3::Client.new(region: ENV['AWS_REGION'])
    for value in buckets do
        puts 'Target Value: ' + value.delete_prefix("image/")
        puts 'Value ' + value
        begin
          s3.copy_object(bucket: target_bucket_name, copy_source: source_bucket_name + '/' + value, key: 'avatar/' + value.delete_prefix("image/"))
          #puts 'Copying ' +  value + ' from bucket ' + source_bucket_name + ' to bucket ' + target_bucket_name
          update_path(value, "avatar/#{value.delete_prefix("image/")}")
        rescue StandardError => ex
          puts 'Caught exception copying object ' + value + ' from bucket ' + source_bucket_name + ' to bucket ' + target_bucket_name + ' as ' + value + ':'
          puts ex.message
        end    
    end
  end
end

if $PROGRAM_NAME == __FILE__
  source_bucket_name = ENV['SOURCE_BUCKET']
  target_bucket_name = ENV['TARGET_BUCKET']
  #Migrate.update_path("imagem/avatar-32426.png", "avatar/avatar-32426.png")
  Migrate.copy(source_bucket_name,target_bucket_name)
end
