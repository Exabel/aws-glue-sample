#!/usr/bin/env bash

. ./configuration.sh

echo "creating load-timeseries-trigger"

command=$(cat <<EOF
aws glue create-trigger \
    --name "load-timeseries-trigger" \
    --description "Run load-timeseries-job after data-entity-mapping-prepare-job SUCCEEDS" \
    --workflow-name "$project_key-workflow" \
    --type "CONDITIONAL" \
    --predicate '{
      "Conditions": [
        {
          "LogicalOperator": "EQUALS",
          "JobName": "timeseries-prepare-job",
          "State": "SUCCEEDED"
        }
      ]
    }' \
    --actions '[
      {
        "JobName": "load-timeseries-job"
      }
    ]' \
    --start-on-creation
EOF
)

eval $command $quiet