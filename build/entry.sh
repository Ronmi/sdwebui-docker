#!/bin/bash

case "$1" in
    --*)
        ;;
    *)
        echo "Running command: ""$@"
        exec "$@"
        ;;
esac

exec ./webui.sh "$@"
