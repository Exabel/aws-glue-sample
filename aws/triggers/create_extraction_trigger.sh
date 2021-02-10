#!/usr/bin/env bash

. ./configuration.sh

echo "creating extraction-trigger - please edit cron settings"

command=$(cat <<EOF
aws glue create-trigger \
    --name extraction-trigger \
    --description "Schedule and start the extraction-job" \
    --workflow-name "$project_key-workflow" \
    --type "SCHEDULED" \
    --schedule "cron(0 18 * * ? *)" \
    --actions '[
      {
        "JobName": "extraction-job",
        "Arguments": {
            "--job-bookmark-option": "job-bookmark-enable"
        },
        "Timeout": 15
      }
    ]' \
    --no-start-on-creation
EOF
)

eval "$command" $quiet