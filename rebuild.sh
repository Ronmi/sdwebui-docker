#!/usr/bin/bash

dir=$(dirname $0)

sed -i "s/ENV LAST_UPDATE=.*/ENV LAST_UPDATE=$(date +%Y-%m-%dT%H:%M:%S)/" "${dir}/build/webui/Dockerfile"

docker compose build
