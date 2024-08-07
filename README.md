Flexible dockerized [stable-diffusion-webui](https://github.com/AUTOMATIC1111/stable-diffusion-webui)

This is complete rewrite of previous version. It is more flexible and easier to use now.

# TL;DR

Currently only NV cards are tested.

Install Docker, git and wget, place yourself in an empty folder and run installer script.

```sh
mkdir sdwebui
cd sdwebui
wget -q -O - https://raw.githubusercontent.com/Ronmi/sdwebui-docker/master/installer.sh | bash
```

Edit `webui/.env`:

For 16GB+ vram:
```txt
COMMANDLING_ARGS="--listen --xformers"
PROTOCOL_BUFFERS_PYTHON_IMPLEMENTATION=python
```

For 8~16GB vram:
```txt
COMMANDLING_ARGS="--listen --xformers --medvram"
PROTOCOL_BUFFERS_PYTHON_IMPLEMENTATION=python
```

For 8~2GB vram:
```txt
COMMANDLING_ARGS="--listen --xformers --lowvram"
PROTOCOL_BUFFERS_PYTHON_IMPLEMENTATION=python
```

then run `docker compose up`

Tested in Debian bookworm and WSL.

# Build install script by yourself

1. Clone this repo.
2. `./build-installer.sh`

# Miniconda instead of python-venv

It's way easier to change base image for installing extra packages with distro you familiar with. It's also easier to use different python version, 3.10.6 instead of latest 3.10.14 for example.

To change base image or install extra utils, edit `build/webui/Dockerfile`. To change python version, edit `build/webui/start.sh`. You have to rebuild the image and recreate the service to apply changes.

# Extra content

There is a `.rmi-work` folder in installed dir. It's setting file which provides useful command line function for zsh users (should be compitable with bash, but not tested). You can simply `source .rmi-work/conf.zsh` to apply it. Refer the file for available command.

For rare user of [my zsh config](https://github.com/Ronmi/25h), just `workhere`.

# FAQ

### Does it run on Mac/AMD/XXX (hardware)

Generally, yes. But you'll have to edit `build/webui/Dockerfile`, `build/webui/start.sh`, `webui/.env` and `docker-compose.yml` by yourself.

### Can I use it with Windows+Docker Desktop

Not tested but I think, yes. Don't file issue about it as I have no Windows machine to test it. You can still file issue to provide detailed step as successful case.

1. Install [git](https://git-scm.com/download/win), [wget](https://gnuwin32.sourceforge.net/packages/wget.htm) and Docker Desktop. Don't forget to enable GPU for container.
2. Create a new folder.
2. Run *Git bash* (not cmd.exe) and cd to the folder (or right click the folder and select `Run Git Bash here`)
3. `wget -q -O - https://raw.githubusercontent.com/Ronmi/sdwebui-docker/master/installer.sh | bash`
4. Start it with Docker Desktop.

I think there might be a problem in installer.sh about how it fetch current uid/gid. Workround is download the installer and remove those line, then fill correct number in `docker-compose.yml` manually.

### Update webui source code

Rebuild the image without using cache:

1. `docker compose build --no-cache`. It also reinstall system pacakges, super slow.
2. Manually edit `build/webui/Dockerfile`, add or update something right before cloneing webui. Run `docker compose build` after editing.
3. `rebuild.sh`, identical to method 2, but using script.

### CivitAI browser+ (extension)

Aria2 binary provided by the extension is not compitable with Debian stable (bookworm) or newer distro (Ubuntu 24.04 for example). Current image has aria2 preinstalled, you just need to update `extensions/sd-civitai-browser-plus/scripts/civitai-download.py`, and change the binary path around L92

```python
        aria2 = '/usr/bin/aria2c'
        stop_rpc = 'pkill aria2c'
        # comment or delete following 2 lines to prevent error
        # st = os.stat(aria2)
        # os.chmod(aria2, st.st_mode | stat.S_IEXEC)
```

And update settings to disable multi-connection (Settings > CivitAI Browser+ > Downloads > Number of connections to use for downloading a model. Set it to 1)

Or, just disable aria2 in settings.

### Manually install extension or configure accelerate

`docker compose run --rm webui bash` creates a shell (in different container) with conda environment activated. You should use this shell to install dependencies manually.

### Install packages temporarily or permanently

To install packages temporarily, use `docker compose exec webui bash` to jump into the container. Besides `sudo apt install`, you can also run `activate.sh` in container to activate conda environment and install python packages.

To install permanently, edit `build/webui/Dockerfile` and rebuild the image.

### Resetting environment

Cleanup `webui/venv` to reinstall python dependencies from cache.

Remove `webui/.cache/pip` to purge pip cache.
