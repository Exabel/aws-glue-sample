#!/usr/bin/env bash

. ./configuration.sh

echo "creating entity-mapping-job in $bucket"

command=$(cat <<EOF
aws glue create-job \
    --name "mapping-prepare-job" \
    --role "$aws_role" \
    --execution-property '{ "MaxConcurrentRuns": 1 }' \
    --command '{
        "Name": "glueetl",
        "ScriptLocation": "s3://'$bucket'/etl/scripts/mapping_prepare_job.py",
        "PythonVersion": "3"
    }' \
    --region "$region" \
    --output "json" \
    --default-arguments '{
        "--bucket": "'$bucket'",
        "--input-key": "data/etl-output/mapping/identities/",
        "--output-key": "data/etl-output/mapping/identities-prepared/",
        "--output-filename": "identities.csv.gz",
        "--TempDir": "s3://'$bucket'/data/etl-output/mapping/temporary",
        "--job-bookmark-option": "job-bookmark-enable",
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
