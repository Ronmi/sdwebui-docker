#!/bin/bash

case "$1" in
    bash|sh)
        exec "$@"
        ;;
    *)
        ;;
esac

exec ./webui.sh "$@"
