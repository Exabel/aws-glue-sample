#!/usr/bin/env bash

. ./configuration.sh

echo "setting up project $project_key"

. ./databases/create_sample_database.sh

. ./crawlers/create_sample_data_crawler.sh

. ./s3/create-project-bucket.sh
. ./s3/libraries/upload-python-libraries.sh
. ./s3/data/upload_sample_data.sh

. ./jobs/create_all_jobs.sh

. ./workflows/create_project_workflow.sh

. ./triggers/create_all_triggers.sh

echo "start crawling sample data"

. ./crawlers/start_crawler.sh