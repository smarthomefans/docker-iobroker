FROM debian:latest

ARG IOBROKER_VERSION="2.0.3"
ARG NODE_VERSION="8.16.0"
ARG EXTRA_HB=""
ARG REGISTRY="https://registry.npmjs.org"

MAINTAINER Andre Germann <https://buanet.de>

ENV DEBIAN_FRONTEND noninteractive

# Install prerequisites
RUN apt-get update && apt-get upgrade -y && apt-get install -y \
        acl \
        apt-utils \
        build-essential \
        curl \
        git \
        gnupg2 \
        libavahi-compat-libdnssd-dev \
        libcap2-bin \
        libpam0g-dev \
        libudev-dev \
        locales \
        procps \
        python \
        gosu \
        unzip \
        wget \
        nano \
        ffmpeg \
    && rm -rf /var/lib/apt/lists/*

# Install node8
RUN curl -sL https://deb.nodesource.com/setup_8.x | bash \
    && apt-get update && apt-get install -y \
        nodejs \
    && rm -rf /var/lib/apt/lists/*
# change registry
RUN npm config set registry ${REGISTRY}

# change node version
RUN npm install -g n && \
    n ${NODE_VERSION} && \
    npm install -g npm

# install global deps
RUN npm explore npm -g -- npm install node-gyp@latest && npm install -g homebridge ${EXTRA_HB}

# Generating locales
RUN sed -i 's/^# *\(zh_CN.UTF-8\)/\1/' /etc/locale.gen \
	&& sed -i 's/^# *\(en_US.UTF-8\)/\1/' /etc/locale.gen \
	&& locale-gen

# Create scripts directory and copy scripts
RUN mkdir -p /opt/scripts/ \
    && chmod 777 /opt/scripts/
WORKDIR /opt/scripts/
COPY scripts/iobroker_startup.sh iobroker_startup.sh
COPY scripts/setup_avahi.sh setup_avahi.sh
COPY scripts/setup_packages.sh setup_packages.sh
RUN chmod +x iobroker_startup.sh \
	&& chmod +x setup_avahi.sh \
    && chmod +x setup_packages.sh

# Install ioBroker
WORKDIR /
RUN apt-get update \
    && curl -sL https://raw.githubusercontent.com/ioBroker/ioBroker/stable-installer/installer.sh | \
    sed -e 's/${INSTALL_TARGET-"iobroker"}/iobroker@${IOBROKER_VERSION}/g' | \
    bash - \
    && echo $(hostname) > /opt/iobroker/.install_host \
    && echo $(hostname) > /opt/.firstrun \
    && rm -rf /var/lib/apt/lists/*

# Install node-gyp
WORKDIR /opt/iobroker/

# Backup initial ioBroker-folder
RUN tar -cf /opt/initial_iobroker.tar /opt/iobroker

# Setting up iobroker-user
RUN chsh -s /bin/bash iobroker

# Setting up ENVs
ENV DEBIAN_FRONTEND="teletype" \
	LANG="zh_CN.UTF-8" \
	LANGUAGE="zh_CN:de" \
	LC_ALL="zh_CN.UTF-8" \
	TZ="Asia/Shanghai" \
	PACKAGES="" \
	AVAHI="false"

# Setting up EXPOSE for Admin
EXPOSE 8081/tcp	

# Run startup-script
ENTRYPOINT ["/opt/scripts/iobroker_startup.sh"]
