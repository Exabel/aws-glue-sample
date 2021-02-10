#!/usr/bin/env bash

. ./configuration.sh

echo "tearing down project $project_key"

. ./databases/delete_sample_database.sh

. ./crawlers/delete_sample_data_crawler.sh

. ./s3/delete-project-bucket.sh

. ./workflows/delete_project_workflow.sh

. ./triggers/delete_all_triggers.sh

. ./jobs/delete_all_jobs.sh
