#!/usr/bin/env bash

. ./configuration.sh

echo "creating $project_key-crawler"

command=$(cat <<EOF
aws glue create-crawler \
  --name "$project_key-crawler" \
  --role "$aws_role" \
  --targets '{
      "S3Targets": [
                    {
                        "Path": "s3://'$bucket'/data/sample-input",
                        "Exclusions": []
                    }
                ],
      "JdbcTargets": [],
      "MongoDBTargets": [],
      "DynamoDBTargets": [],
      "CatalogTargets": []
  }' \
  --database-name "$database_name" \
  --recrawl-policy '{
      "RecrawlBehavior": "CRAWL_EVERYTHING"
  }' \
  --schema-change-policy '{
      "UpdateBehavior": "UPDATE_IN_DATABASE",
      "DeleteBehavior": "DEPRECATE_IN_DATABASE"
  }' \
  --lineage-configuration '{
      "CrawlerLineageSettings": "DISABLE"
  }' \
  --table-prefix "$database_table_prefix"
EOF
)

eval $command $quiet