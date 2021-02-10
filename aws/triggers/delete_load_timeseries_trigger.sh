#!/usr/bin/env bash

. ./configuration.sh

eval aws glue delete-trigger --name load-timeseries-trigger $quiet