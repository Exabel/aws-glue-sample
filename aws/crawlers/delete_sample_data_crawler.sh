#!/usr/bin/env bash

. ./configuration.sh

echo "deleting $project_key-crawler"

eval aws glue delete-crawler --name "$project_key-crawler" $quiet