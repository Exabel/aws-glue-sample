#!/usr/bin/env bash

. ./configuration.sh

echo "deleting test project database $database_name"

eval aws glue delete-database --name "$database_name" $quiet