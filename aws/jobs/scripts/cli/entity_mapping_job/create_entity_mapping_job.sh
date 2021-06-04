#!/usr/bin/env bash

. ./configuration.sh

echo "creating entity-mapping-job in $bucket"

command=$(cat <<EOF
aws glue create-job \
    --name "entity-mapping-job" \
    --role "$aws_role" \
    --command '{
        "Name": "pythonshell",
        "ScriptLocation": "s3://'$bucket'/etl/scripts/entity_mapping_job.py",
        "PythonVersion": "3"
    }' \
    --execution-property '{ "MaxConcurrentRuns": 1 }' \
    --region $region \
    --output "json" \
    --default-arguments '{
        "--exabel-api-key": "'$exabel_api_key'",
        "--exabel-api-host": "'$exabel_api_host'",
        "--bucket": "'$bucket'",
        "--input-key": "data/etl-output/mapping/identities-prepared/",
        "--input-filename": "identities.csv.gz",
        "--output-key": "data/etl-output/mapping/entity-mapping/",
        "--output-filename": "entity_mapping.csv",
        "--extra-py-files": "$extra_py_files",
        "--job-bookmark-option": "job-bookmark-disable",
        "--job-language": "python"
    }' \
    --max-retries 0 \
    --allocated-capacity 0 \
    --timeout 15 \
    --max-capacity 0.0625 \
    --glue-version "1.0"
EOF
)

eval $command $quiet