#!/usr/bin/env bash

. ./configuration.sh

eval aws glue delete-job --job-name "entity-mapping-job" $quiet