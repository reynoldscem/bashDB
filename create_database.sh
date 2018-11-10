#!/bin/bash

# shellcheck source=functions.sh
source "$(dirname "$0")/functions.sh"

if [ -z "$1" ]; then
  eval "${no_param}"
fi
database=$1

if [ -d "$database" ]; then
  eval "${db_exists}"
# If another process is trying to create the same database we don't really care.
elif mkdir -p "$database"; then
  eval "${db_created}"
else
  exit 1
fi
