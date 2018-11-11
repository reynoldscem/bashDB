#!/bin/bash

this_dir="$(dirname "$0")"

# shellcheck source=functions.sh
source "${this_dir}/functions.sh"

server_pipe="${this_dir}/server.pipe"
if [ ! -p "$server_pipe" ]; then
    eval "${server_pipe_exists}"
fi

if [ -z "$1" ]; then
    eval "${param_problem}"
fi
pipe_name="client.${1}.pipe"
attempt_work "${this_dir}/${pipe_name}" \
  "mkfifo ${pipe_name}" \
  ""
trap 'rm -f "${pipe_name}"; exit $?' INT

while read -r input; do
  echo "${1}" "$input" >> "$server_pipe"
  while read -r line <>"$pipe_name"; do
      echo "$line"
      [[ $line == Error* ]] && break
      [[ $line == OK* ]] && break
      [[ $line == end_results* ]] && break
  done
done
