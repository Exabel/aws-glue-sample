#!/usr/bin/env bash

. ./configuration.sh

echo "upload entity_mapping_job script to $bucket"

eval aws s3 cp ./jobs/scripts/pythonshell/entity_mapping_job.py s3://$bucket/etl/scripts/ $quiet
