#!/bin/bash

# shellcheck source=functions.sh
source "$(dirname "$0")/functions.sh"

if [ "$#" -ne 3 ]; then
  eval "${param_problem}"
fi

database=$1
table=$2
columns=$3

if [ ! -d "$database" ]; then
  eval "${db_doesnt_exist}"
fi
table_path="${database}/${table}"

if [ -f "${table_path}" ]; then
  eval "${table_exists}"
fi

lock_name="${table_path}.lock"
wait_time=$(bc -l <<< '1.0 / 2^7')
while [ "$(printf "%.0f" "$wait_time")" -lt $(( 2 ** 3 )) ]; do
  # noclobbber causes pipe to return failure if file exists.
  if ( set -o noclobber; echo "locked" > "$lock_name") 2> /dev/null; then
    # If something bad happens remove the lock and exit with last seen status code
    trap 'rm -f "$lock_name"; exit $?' INT TERM EXIT

    # Ok actually do the work
    echo "$columns" > "${table_path}"

    # Done with the lock
    rm -f "$lock_name"

    # Finish and quit
    eval "${table_created}"
  else
    sleep "$wait_time"
    # Exponential back off
    wait_time=$(bc -l <<< "${wait_time} * 2")
  fi
done
eval "${timeout}"
