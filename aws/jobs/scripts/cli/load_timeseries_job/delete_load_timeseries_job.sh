#!/usr/bin/env bash

. ./configuration.sh

eval aws glue delete-job --job-name "load-timeseries-job" $quiet