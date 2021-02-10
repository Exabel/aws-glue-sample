#!/usr/bin/env bash

. ./configuration.sh

echo "uploading sample data to $bucket"

eval aws s3 cp s3/data/chain_tickers.csv s3://$bucket/data/sample-input/chain-tickers/ $quiet
eval aws s3 cp s3/data/chain_venues.csv s3://$bucket/data/sample-input/chain-venues/ $quiet
eval aws s3 cp s3/data/rvf_sample.csv s3://$bucket/data/sample-input/data-set/ $quiet
