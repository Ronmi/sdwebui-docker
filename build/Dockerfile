FROM nvidia/cuda:12.1.1-runtime-ubuntu22.04

ARG http_proxy

RUN ( \
    echo "tzdata tzdata/Areas select Asia" ; \
    echo "tzdata tzdata/Zones/Asia select Taipei" ; \
    echo "debconf debconf/frontend select Noninteractive" \
    ) > /tmp/asd && \
    debconf-set-selections /tmp/asd && \
    rm /tmp/asd
RUN DEBIAN_FRONTEND=noninteractive TZ=Asia/Taipei apt-get update && \
    apt-get install -y tzdata python3 python3-venv python3-pip build-essential \
    git git-lfs curl ca-certificates wget libtcmalloc-minimal4 cmake ffmpeg \
    python3-dev libbz2-dev libgdbm-compat-dev libgdbm-dev liblzma-dev tk-dev \
    libncurses5-dev libncursesw5-dev libreadline-dev libsqlite3-dev libssl-dev lzma-dev && \
    apt-get clean -y && rm -fr /var/lib/apt/lists/* && (export HOME=/tmp; cd /tmp; git lfs install)

ADD entry.sh /usr/bin/entry.sh
ENTRYPOINT ["/usr/bin/entry.sh"]
CMD ["--listen", "--enable-insecure-extension-access"]
