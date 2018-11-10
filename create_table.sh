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
  if ( set -o noclobber; echo "locked" > "$lock_name") 2> /dev/null; then
    trap 'rm -f "$lock_name"; exit $?' INT TERM EXIT
    echo "Locking succeeded"
    echo "$columns" > "${table_path}"
    rm -f "$lock_name"
    eval "${table_created}"
  else
    echo "don't have lock, sleep $wait_time"
    sleep "$wait_time"
    wait_time=$(bc -l <<< "${wait_time} * 2")
  fi
done
eval "${timeout}"
