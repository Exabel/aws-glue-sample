#!/usr/bin/env bash

. ./configuration.sh

echo "creating extraction-job in $bucket"

command=$(cat <<EOF
aws glue create-job \
    --name "extraction-job" \
    --description "Extract timeseries and mapping data from source" \
    --role "$aws_role" \
    --command '{
        "Name": "glueetl",
        "ScriptLocation": "s3://'$bucket'/etl/scripts/extraction_job.py",
        "PythonVersion": "3"
    }' \
    --execution-property '{ "MaxConcurrentRuns": 1 }' \
    --region $region \
    --output "json" \
    --default-arguments '{
        "--bucket": "'$bucket'",
        "--database-name": "'$database_name'",
        "--database-table-prefix": "'$database_table_prefix'",
        "--TempDir": "s3://'$bucket'/etl/temporary/",
        "--class": "GlueApp",
        "--enable-continuous-cloudwatch-log": "true",
        "--enable-glue-datacatalog": "true",
        "--enable-spark-ui": "true",
        "--job-bookmark-option": "job-bookmark-disable",
        "--job-language": "python",
        "--spark-event-logs-path": "s3://'$bucket'/etl/sparkHistoryLogs/",
        "--job-bookmark-option": "job-bookmark-disable",
        "--job-language": "python"
    }' \
    --max-retries 0 \
    --timeout 15 \
    --worker-type "G.1X" \
    --number-of-workers 3 \
    --glue-version "2.0"
EOF
)

eval $command $quiet