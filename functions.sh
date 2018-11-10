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

# Separate a string using ',', then count the fields.
count_fields() {
  IFS=','
  read -ra line_array <<<"$1"
  echo "${#line_array[@]}"
}
