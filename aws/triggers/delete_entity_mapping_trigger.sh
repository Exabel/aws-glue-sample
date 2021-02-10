#!/usr/bin/env bash

. ./configuration.sh

eval aws glue delete-trigger --name entity-mapping-trigger $quiet