FROM debian

ARG APP_UID=1000
ARG APP_GID=1000

# aria2 is used by modified civitai browser+, see README.md for detail
RUN apt-get update && apt-get install -y \
    sudo python3 git git-lfs bc wget curl ca-certificates less procps \
    libtcmalloc-minimal4 libgl1 libglib2.0-0 \
    build-essential libcairo2-dev pkg-config python3-dev \
    aria2 \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN addgroup --gid ${APP_GID} user \
    && adduser --uid ${APP_UID} --gid ${APP_GID} --disabled-password --gecos "" user \
    && adduser user sudo

USER user
WORKDIR /home/user

# install miniconda
RUN wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O miniconda.sh \
    && bash miniconda.sh -b -p /home/user/miniconda \
    && rm miniconda.sh

# this line is preserved for update webui source easier
ENV LAST_UPDATE=1995-09-22T00:00:00

# clone webui with hack
RUN git lfs install && \
    git clone https://github.com/AUTOMATIC1111/stable-diffusion-webui webui && \
    sed -i -e 's/fastapi==0.90.1/fastapi==0.89.1/g' webui/requirements_versions.txt && \
    mkdir /home/user/webui/repositories

ENV venv_dir=-
WORKDIR /home/user
COPY start.sh /usr/local/bin/start.sh
ENTRYPOINT ["/usr/local/bin/start.sh"]
