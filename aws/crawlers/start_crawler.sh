#!/usr/bin/env bash

. ./configuration.sh

echo "starting $project_key-crawler"

eval aws glue start-crawler --name "$project_key-crawler" $quiet