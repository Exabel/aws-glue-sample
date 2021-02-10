#!/usr/bin/env bash

. ./configuration.sh

echo "creating project bucket '$bucket' in region '$region'"

aws s3 mb s3://$bucket --region $region