#!/usr/bin/env bash

. ./configuration.sh

echo "deleting $project_key-workflow"

eval aws glue delete-workflow --name "$project_key-workflow" $quiet