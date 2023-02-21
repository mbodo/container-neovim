FROM docker.io/library/debian:bullseye

ENV TZ=Europe/Bratislava

RUN set -eux; \
	    apt-get update; \
        apt-get install -y --no-install-recommends \
            ninja-build \
            gettext \
            libtool \
            libtool-bin \
            autoconf \
            automake \
            cmake \
            g++ \
            pkg-config \
            unzip \
            curl \
            doxygen \
            git \
            ca-certificates \
            make \
            locales \
            xclip \
            ripgrep \
            tree \
        ; \
        rm -rf /var/lib/apt/lists/*

RUN set -eux; \
        apt-get update; apt-get install -y --no-install-recommends locales; rm -rf /var/lib/apt/lists/*; \
        localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8
ENV LANG en_US.utf8

# Install Neovim from source.
ARG VERSION=stable
RUN set -eux; \ 
        cd /tmp && \
        git clone https://github.com/neovim/neovim && \
        cd neovim && \
        git checkout ${VERSION} && \
        make CMAKE_BUILD_TYPE=Release && \
        make install

# Install Neovim python integration
RUN set -eux; \
	apt-get update; \
    apt-get install -y --no-install-recommends \
        python3 \
        python3-pip \
    ; \
    rm -rf /var/lib/apt/lists/*; \
    pip3 install pynvim

# Install Neovim ruby integration
RUN set -eux; \
	apt-get update; \
    apt-get install -y --no-install-recommends \
        ruby \
        ruby-dev \
    ;\
    rm -rf /var/lib/apt/lists/*; \
    gem install neovim

# Install Neovim nodejs integration
RUN set -eux; \
	apt-get update; \
    apt-get install -y --no-install-recommends \
        nodejs \
        npm \
    ; \
    rm -rf /var/lib/apt/lists/*; \
    npm i -g neovim; \
    npm i -g n; \
    n stable

RUN mkdir -p /root/.config; \
    mkdir -p /root/.local/share/nvim
