#!/usr/bin/env bash

. ./configuration.sh

echo "creating test project database $database_name"

command=$(cat <<EOF
aws glue create-database --database-input '{
    "Name": "'$database_name'",
    "LocationUri": "'$region'",
    "CreateTableDefaultPermissions": [
        {
            "Principal": {
                "DataLakePrincipalIdentifier": "IAM_ALLOWED_PRINCIPALS"
            },
            "Permissions": [
                "ALL"
            ]
        }
    ]
}'
EOF
)

eval $command $quiet