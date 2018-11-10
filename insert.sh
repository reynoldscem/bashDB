#!/bin/bash

# shellcheck source=functions.sh
source "$(dirname "$0")/functions.sh"

if [ "$#" -ne 3 ]; then
  eval "${param_problem}"
fi

database=$1
table=$2
tuple=$3

if [ ! -d "$database" ]; then
  eval "${db_doesnt_exist}"
fi
table_path="${database}/${table}"

if [ ! -f "${table_path}" ]; then
  eval "${table_doesnt_exist}"
fi

schema=$(head -n1 "${table_path}")
schema_field_count=$(eval count_fields "${schema}")
tuple_field_count=$(eval count_fields "${tuple}")

if [ ! "$schema_field_count" -eq "$tuple_field_count" ]; then
  eval "${schema_mismatch}"
fi

echo "${tuple}" >> "${table_path}"
eval "${tuple_inserted}"
