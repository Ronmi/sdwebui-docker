Bit easier to run [stable-diffusion-webui](https://github.com/AUTOMATIC1111/stable-diffusion-webui) with Docker, tested in Debian (bullseye, bookworm) and WSL2 (Windows 10).

# How to install

- install git using package manager your distro provides
- clone this repo or download and extract the zip from github
- run `./prepare.sh`
- ensure everything on the checklist is ready

# The checklist

- You'll have to download a few large files, model in particular, make sure you have decent internet connection
- x86_64 machine and NVIDIA card, indeed
- official (proprietary) NVIDIA driver
- [Docker](https://docs.docker.com/engine/install/)
- [CUDA support for Docker](https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/latest/install-guide.html)
- edit `./build/Dockerfile` and `./docker-compose.yml` to fit your need, timezone in particular
- edit `./webui-user.sh`

You don't have to install python or cuda toolkit as they are installed in container.

# How to use

- `docker compose up` or `docker compose up -d`
- wait a while until webui is ready
- open [http://127.0.0.1:7860](http://127.0.0.1:7860) in your browser

# How to enable accelerate

- `docker compose run --rm webui bash`
- `source venv/bin/activate`
- `accelerate config`
- `exit`
- edit `./webui-user.sh` and restart the container

# How to update

- run `docker compose build --pull` to update the image, you have to restart the webui after that
- run `git pull` in `./stable-diffusion-webui` to update the webui

# How to uninstall

- `docker compose down --rmi all`
- remove the folder
