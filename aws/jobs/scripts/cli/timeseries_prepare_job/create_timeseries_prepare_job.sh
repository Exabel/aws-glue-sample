#!/usr/bin/env bash

. ./configuration.sh

echo "creating timeseries-prepare-job in $bucket"

command=$(cat <<EOF
aws glue create-job \
    --name "timeseries-prepare-job" \
    --role "$aws_role" \
    --command '{
        "Name": "glueetl",
        "ScriptLocation": "s3://'$bucket'/etl/scripts/timeseries_prepare_job.py",
        "PythonVersion": "3"
    }' \
    --execution-property '{ "MaxConcurrentRuns": 1 }' \
    --region $region \
    --output "json" \
    --default-arguments '{
        "--bucket": "'$bucket'",
        "--data-key": "data/etl-output/time-series/extracted",
        "--mapping-key": "data/etl-output/mapping/entity-mapping/",
        "--mapping-filename": "entity_mapping.csv",
        "--output-key": "data/etl-output/time-series/prepared/",
        "--output-filename": "timeseries.csv.gz",
        "--TempDir": "s3://'$bucket'/data/etl-output/load/temporary",
        "--job-bookmark-option": "job-bookmark-disable",
        "--job-language": "python"
    }' \
    --max-retries 0 \
    --allocated-capacity 3 \
    --timeout 15 \
    --glue-version "2.0"
EOF
)

eval $command $quiet
