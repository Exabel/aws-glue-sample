#!/usr/bin/env bash

echo "deleting triggers"

. ./triggers/delete_extraction_trigger.sh
. ./triggers/delete_mapping_prepare_trigger.sh
. ./triggers/delete_entity_mapping_trigger.sh
. ./triggers/delete_timeseries_prepare_trigger.sh
. ./triggers/delete_load_timeseries_trigger.sh
