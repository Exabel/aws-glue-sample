#!/usr/bin/env bash

. ./configuration.sh

echo "upload extraction_job script to $bucket"

eval aws s3 cp ./jobs/scripts/pyspark/extraction_job.py s3://$bucket/etl/scripts/ $quiet