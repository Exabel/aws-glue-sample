#!/usr/bin/env bash

. ./configuration.sh

echo "creating timeseries-prepare-trigger"

command=$(
  cat <<EOF
aws glue create-trigger \
    --name "timeseries-prepare-trigger" \
    --description "Run timeseries-prepare-job after entity-mapping-job SUCCEEDS" \
    --workflow-name "$project_key-workflow" \
    --type "CONDITIONAL" \
    --predicate '{
      "Conditions": [
        {
          "LogicalOperator": "EQUALS",
          "JobName": "entity-mapping-job",
          "State": "SUCCEEDED"
        }
      ]
    }' \
    --actions '[
      {
        "JobName": "timeseries-prepare-job"
      }
    ]' \
    --start-on-creation
EOF
)

eval $command $quiet