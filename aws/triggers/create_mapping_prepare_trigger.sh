#!/usr/bin/env bash

. ./configuration.sh

echo "creating mapping-prepare-trigger"

command=$(
  cat <<EOF
aws glue create-trigger \
    --name "mapping-prepare-trigger" \
    --description "Run mapping-prepare-job after extraction-job SUCCEEDS" \
    --workflow-name "$project_key-workflow" \
    --type "CONDITIONAL" \
    --predicate '{
      "Conditions": [
        {
          "LogicalOperator": "EQUALS",
          "JobName": "extraction-job",
          "State": "SUCCEEDED"
        }
      ]
    }' \
    --actions '[
      {
        "JobName": "mapping-prepare-job"
      }
    ]' \
    --start-on-creation
EOF
)

eval $command $quiet