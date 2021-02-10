#!/usr/bin/env bash

echo "creating triggers"

. ./triggers/create_extraction_trigger.sh
. ./triggers/create_mapping_prepare_trigger.sh
. ./triggers/create_entity_mapping_trigger.sh
. ./triggers/create_timeseries_prepare_trigger.sh
. ./triggers/create_load_timeseries_trigger.sh
