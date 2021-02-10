#!/usr/bin/env bash

. ./configuration.sh

echo "creating jobs for $project_key"

. ./jobs/scripts/cli/extraction_job/create_extraction_job.sh
. ./jobs/scripts/cli/extraction_job/upload_extraction_job_script.sh

. ./jobs/scripts/cli/entity_mapping_job/create_entity_mapping_job.sh
. ./jobs/scripts/cli/entity_mapping_job/upload_entity_mapping_job_script.sh

. ./jobs/scripts/cli/load_timeseries_job/create_load_timeseries_job.sh
. ./jobs/scripts/cli/load_timeseries_job/upload_load_timeseries_job_script.sh

. ./jobs/scripts/cli/mapping_prepare_job/create_mapping_prepare_job.sh
. ./jobs/scripts/cli/mapping_prepare_job/upload_mapping_prepare_job_script.sh

. ./jobs/scripts/cli/timeseries_prepare_job/create_timeseries_prepare_job.sh
. ./jobs/scripts/cli/timeseries_prepare_job/upload_timeseries_prepare_job_script.sh

