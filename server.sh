#!/bin/bash

this_dir="$(dirname "$0")"

# shellcheck source=functions.sh
source "${this_dir}/functions.sh"
select="${this_dir}/select.sh"
insert="${this_dir}/insert.sh"
create_table="${this_dir}/create_table.sh"
create_database="${this_dir}/create_database.sh"

while read -r input; do
  case "$input" in
    create_database*)
      eval "$create_database $(cut -d' ' -f2- <<<"$input")" &
      ;;
    create_table*)
      eval "$create_table $(cut -d' ' -f2- <<<"$input")" &
      ;;
    insert*)
      eval "$insert $(cut -d' ' -f2- <<<"$input")" &
      ;;
    select*)
      eval "$select $(cut -d' ' -f2- <<<"$input")" &
      ;;
    *)
      eval "${bad_request}"
  esac
done
