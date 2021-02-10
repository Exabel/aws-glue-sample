#!/usr/bin/env bash

. ./configuration.sh

echo "upload load_timeseries_job script to $bucket"

eval aws s3 cp ./jobs/scripts/pythonshell/load_timeseries_job.py s3://$bucket/etl/scripts/ $quiet
