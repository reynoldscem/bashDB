# BashDB

Simple filesytem-based database in `bash`.

Usage:

Run a single server with `./server.sh`

Any number of clients can be run, with unique identifiers, like `./client.sh id_0`.

Clients read commands from `stdin`, and forward them to the server. The server
executes commands concurrently, and sends output back to the corresponding
client.

Mutexes protect files from concurrent editing. A command will retry on an
exponential backoff to obtain a mutex, and eventually timeout.

Supported commands, with examples:

- `create_database library`
- `create_table library books title,pages,category`
- `insert library books Harry_Potter,1000,fiction`
- `select library books 1,3`

The whole thing is hacky `bash`. Feedback / PRs / forks for general improvements
or to improve brittleness are very welcome.
