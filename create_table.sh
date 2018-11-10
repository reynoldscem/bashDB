#!/bin/bash

source functions.sh

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

echo "$columns" > "${table_path}"
eval "${table_created}"
