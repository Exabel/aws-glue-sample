#!/usr/bin/env bash

. ./configuration.sh

echo "deleting jobs for $project_key"

. ./jobs/scripts/cli/extraction_job/delete_extraction_job.sh

. ./jobs/scripts/cli/entity_mapping_job/delete_entity_mapping_job.sh

. ./jobs/scripts/cli/load_timeseries_job/delete_load_timeseries_job.sh

. ./jobs/scripts/cli/mapping_prepare_job/delete_mapping_prepare_job.sh

. ./jobs/scripts/cli/timeseries_prepare_job/delete_timeseries_prepare_job.sh

