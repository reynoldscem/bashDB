#!/bin/bash

this_dir="$(dirname "$0")"

# shellcheck source=functions.sh
source "${this_dir}/functions.sh"
select="${this_dir}/select.sh"
insert="${this_dir}/insert.sh"
create_table="${this_dir}/create_table.sh"
create_database="${this_dir}/create_database.sh"

server_pipe="${this_dir}/server.pipe"
if [ -p "$server_pipe" ]; then
    eval "${server_pipe_exists}"
fi
mkfifo "$server_pipe"
trap 'rm -f "$server_pipe"; exit $?' INT TERM EXIT

# <>"$server_pipe" ensures that the pipe is kept open, as read has the pipe
#  open for writing, despite not actually outputting anything into it.
while read -r input <>"$server_pipe"; do
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
