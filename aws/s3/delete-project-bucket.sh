#!/usr/bin/env bash

# WARNING - this will remove *everything* in this bucket
# will only work if you have delete access

. ./configuration.sh

echo "delete bucket '$bucket' in region '$region'"

eval aws s3 rm s3://$bucket --region $region --recursive $quiet
eval aws s3 rb s3://$bucket --region $region $quiet