#!/usr/bin/env bash

# Configuration for sample AWS project

# Key used in the project
# Warning: this needs to be globally unique for S3 buckets so don't be too generic
project_key='exabel-aws-test'

# The AWS region to use
region='us-west-2'

# AWS role for Glue
aws_role='<aws role arn for glue>'

# The name of the S3 bucket to use
bucket="$project_key-bucket"

# The name of the database to use for crawled sample data
database_name="$project_key-db"

# Prefix to use on crawled database tablenames
database_table_prefix="sample_"

# Exabel API provided by Exabel
exabel_api_key='<exabel api key>'

# Exabel API hostname provided by Exabel
exabel_api_host='<exabel api host>'

# A comma separated list of signal entities provided by Exabel corresponding to the signals to be
# created in the Exabel database
signals="<signal1, signal2>"

# A list of library wheel files to pass to the pythonshell jobs
# Add your own libraries here if necessary
extra_py_files="s3://$bucket/python/libraries/s3fs-0.4.2-py3-none-any.whl, s3://$bucket/python/libraries/exabel_data_sdk-0.0.9-py3-none-any.whl"

# Let script run without output interruptions - use empty version if you want to see output from aws
quiet="> /dev/null"
#quiet=""