FROM ruby:2.6.4

COPY Gemfile Gemfile
RUN bundle install

COPY . /app
WORKDIR /app

CMD ["ruby","migrate.rb"]