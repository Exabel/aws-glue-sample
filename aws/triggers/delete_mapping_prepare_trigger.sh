#!/usr/bin/env bash

. ./configuration.sh

eval aws glue delete-trigger --name mapping-prepare-trigger $quiet