#!/usr/bin/env bash

. ./configuration.sh

echo "creating $project_key-workflow"

command=$(cat <<EOF
aws glue create-workflow \
  --name "$project_key-workflow" \
  --description "Workflow for test project" \
  --max-concurrent-runs 1
EOF
)

eval $command $quiet
