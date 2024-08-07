#!/usr/bin/bash

# check if user wants to run shell
venv=/home/user/webui/venv
if [[ $1 == "bash" ]]; then
    /bin/bash --init-file <(echo "source ~/miniconda/etc/profile.d/conda.sh ; if [[ ! -d '${venv}/bin' ]]; then conda create -y -k --prefix '$venv' python=3.10;fi;conda activate '$venv'")
    exit $?
fi

set -e

# check rependencies
function check_dep {
    if [[ -d "webui/repositories/$2" ]]; then
        return
    fi
    git clone "$1" "webui/repositories/$2"
}

check_dep https://github.com/AUTOMATIC1111/stable-diffusion-webui-assets.git stable-diffusion-webui-assets
check_dep https://github.com/CompVis/stable-diffusion.git stable-diffusion-stability-ai
check_dep https://github.com/Stability-AI/generative-models.git generative-models
check_dep https://github.com/crowsonkb/k-diffusion.git k-diffusion
check_dep https://github.com/salesforce/BLIP.git BLIP


# check environment is ready
source ~/miniconda/etc/profile.d/conda.sh
if [[ -d "${venv}/bin" ]]; then
    conda activate "$venv"
else
    conda create -y -k --prefix "$venv" python=3.10
fi

# tell webui that it doesn't have to activate environment
export venv_dir=-

# activate environment and run webui
cd webui
conda activate "$venv"
exec ./webui.sh "$@"
