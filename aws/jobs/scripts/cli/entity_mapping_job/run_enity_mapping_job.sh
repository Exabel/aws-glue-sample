#!/usr/bin/env bash

# use --arguments to override job args

aws glue start-job-run \
    --job-name "entity-mapping-job" \
    --arguments '{
    }'