#!/usr/bin/bash

if [[ ! -d stable-diffusion-webui ]]
then
  git clone https://github.com/AUTOMATIC1111/stable-diffusion-webui || exit $?
fi

if [[ ! -f webui-user.sh ]]
then
  cp stable-diffusion-webui/webui-user.sh .
fi

if [[ ! -f docker-compose.yml ]]
then
    cp tmpl.yaml docker-compose.yml
    (
        _uid="$(id -u)"
        _gid="$(id -g)"
        sed -i "s#user: 1000:1000#user: ${_uid}:${_gid}#" docker-compose.yml
    )
fi

function ensure_dir {
    if [[ ! -d "$1" ]]
    then
        mkdir -p "$1"
    fi
}

ensure_dir cache/config
ensure_dir cache/nv
ensure_dir cache/pip
