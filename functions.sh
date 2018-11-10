#!/bin/bash

exit_function() {
  MESSAGE=$1
  CODE=$2
  STATUS=$([ "$2" == 0 ] && echo "OK" || echo "Error")

  echo "${STATUS}: ${MESSAGE}"
  exit "$CODE"
}
export table_doesnt_exist="exit_function 'table does not exist' 1"
export table_exists="exit_function 'table already exists' 1"

export db_doesnt_exist="exit_function 'DB does not exist' 1"
export db_exists="exit_function 'DB already exists' 1"

export column_doesnt_exist="exit_function 'column does not exist' 1"

export schema_mismatch="exit_function 'number of columns in tuple does not match schema' 1"

export param_problem="exit_function 'parameter problem' 1"
export no_param="exit_function 'no parameter' 1"

export db_created="exit_function 'database created' 0"
export table_created="exit_function 'table created' 0"
export tuple_inserted="exit_function 'tuple inserted' 0"

export bad_request="exit_function 'bad request' 1"

export timeout="exit_function 'timeout' 1"

# Separate a string using ',', then count the fields.
count_fields() {
  IFS=','
  read -ra line_array <<<"$1"
  echo "${#line_array[@]}"
}
attempt_work() {
  needed_file="$1"
  pre_lock="$2"
  post_lock="$3"

  lock_name="${needed_file}.lock"
  wait_time=$(bc -l <<< '1.0 / 2^7')
  while [ "$(printf "%.0f" "$wait_time")" -lt $(( 2 ** 3 )) ]; do
    # noclobbber causes pipe to return failure if file exists.
    if ( set -o noclobber; echo "locked" > "$lock_name") 2> /dev/null; then
      # If something bad happens remove the lock and exit with last seen status code
      trap 'rm -f "$lock_name"; exit $?' INT TERM EXIT

      # Ok actually do the work
      eval "$pre_lock"
      # ls company
      # sleep 1

      # Done with the lock
      rm -f "$lock_name"
      # ls company

      # Finish and quit
      eval "$post_lock"

      # Post lock should exit.
      exit 1
    else
      sleep "$wait_time"
      # echo "$wait_time"
      # Exponential back off
      wait_time=$(bc -l <<< "${wait_time} * 2")
    fi
  done
  eval "${timeout}"
}
