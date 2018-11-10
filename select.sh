#!/bin/bash

source functions.sh
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

if [ ! -f "${table_path}" ]; then
  eval "${table_doesnt_exist}"
fi

schema=$(head -n1 "${table_path}")
schema_field_count=$(eval count_fields "${schema}")

IFS=","
for entry in ${columns}; do
  # -eq fails in not integer.
  [ "${entry}" -eq "${entry}" ] 2> /dev/null || eval "${column_doesnt_exist}" 

  # Numbers must be between 1 and the number of fields.
  [ "${entry}" -lt "1" ] && eval "${column_doesnt_exist}"
  [ "${entry}" -gt "${schema_field_count}" ] && eval "${column_doesnt_exist}"
done

echo "start_result"

while read -r line; do
  for column in ${columns}; do
    # Print this column from line, replace newline with ','
    cut -d',' -f"${column}" <<< "$line" | tr $'\n' ','
  done
  # Delete last ','
  echo -e '\b '

# Read in table, from second line to ignore header.
done < <(tail -n +2 "${table_path}")

echo "end_result"
