# Migration script

## Table of Contents

- [Migration script](#migration-script)
  - [Table of Contents](#table-of-contents)
  - [Requirements](#requirements)
  - [Running](#running)
  - [Permissions](#permissions)
    - [AWS S3](#aws-s3)
      - [Source Bucket](#source-bucket)
      - [Target Bucket](#target-bucket)
    - [Database](#database)
  - [Todo](#todo)

## Requirements

- Docker
- docker-compose (to test locally only)

## Running

Create the `.env` based on `.env.example`

```bash
cp .env.example .env
```

Modify the .env content based on your informations and run the migration

```bash
make migrate
```

## Permissions

### AWS S3

#### Source Bucket

The AWS key used need to have the policy `AmazonS3ReadOnlyAccess` can be used, but you can create your policy specific to source bucket as allowed resource with read access.

#### Target Bucket

The AWS key used need to have the policy `AmazonS3FullAccess` can be used, but you can create your policy specific to source bucket as allowed resource with read and write access.

### Database

The db user need to have the `UPDATE` privilege

## Todo

- [ ] Terraform to create the DB (RDS?)
- [ ] Terraform to create the IAM policy
- [ ] Terraform to create the buckets
- [ ] Script to generate objects and populate the buckets
- [ ] Integration test
