#!/usr/bin/env bash

. ./configuration.sh

echo "creating entity-mapping-trigger"

command=$(cat <<EOF
aws glue create-trigger \
    --name entity-mapping-trigger \
    --description "Run entity-mapping-job after mapping-prepare-job SUCCEEDS" \
    --workflow-name "$project_key-workflow" \
    --type "CONDITIONAL" \
    --predicate '{
      "Conditions": [
        {
          "LogicalOperator": "EQUALS",
          "JobName": "mapping-prepare-job",
          "State": "SUCCEEDED"
        }
      ]
    }' \
    --actions '[
      {
        "JobName": "entity-mapping-job"
      }
    ]' \
    --start-on-creation
EOF
)

eval $command $quiet