#!/bin/bash

# See: https://www.gnu.org/software/bash/manual/html_node/The-Set-Builtin.html#The-Set-Builtin
set -e
# (same as set -o errexit)

# Run (startup) scripts for the entrypoint if any:
if [ $# -eq 0 ]; then
    if [ -d '/docker-entrypoint.d' ]; then
        # for f in /docker-entrypoint.d/*; do
        #     case "$f" in
        #         *.sh)     echo "[$0: running $f]"; . "$f" ;;
        #         *)  if [[ ! $f =~ \*$ ]]; then
        #                 echo "[$0: ignoring $f]"
        #             fi
        #         ;;
        #     esac
        #     echo
        # done
        for f in /docker-entrypoint.d/*.sh; do
            . "$f" "$@"
        done
    fi
    # exec /usr/local/bin/start-jobber.sh
    /usr/local/bin/start-jobber.sh
else
    exec "$@"
fi
