#!/usr/bin/env bash

. ./configuration.sh

echo "upload timeseries_prepare_job script to $bucket"

eval aws s3 cp ./jobs/scripts/pyspark/timeseries_prepare_job.py s3://$bucket/etl/scripts/ $quiet