#!/usr/bin/env bash

. ./configuration.sh

echo "uploading python libraries to $bucket"

eval aws s3 cp s3/libraries/exabel_data_sdk-0.0.9-py3-none-any.whl s3://$bucket/python/libraries/ $quiet
eval aws s3 cp s3/libraries/s3fs-0.4.2-py3-none-any.whl s3://$bucket/python/libraries/ $quiet