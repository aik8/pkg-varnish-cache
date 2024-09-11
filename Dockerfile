FROM ubuntu:noble

# Install dependencies
RUN apt-get update && apt-get upgrade -y && apt-get install -y \
    build-essential \
    devscripts \
    dh-make \
    fakeroot \
    lintian \
    debhelper \
    git \
    pkg-config \
    python3-docutils \
    python3-sphinx \
    curl \
    libpcre2-dev \
    libpcre3-dev \
    libjemalloc-dev \
    libedit-dev \
    libncurses-dev \
    libtool \
    autoconf \
    automake \
    python3-pytest \
    rename \
    wget

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive
ENV DEBFULLNAME=Jiannis
ENV DEBEMAIL=email@example.com
ENV REL=noble
ENV ARCH=amd64

ARG VERSION=
ARG CUSTOM_VER=

# Get our pkg build script.
RUN git clone https://github.com/aik8/pkg-varnish-cache.git /varnish

# Switch to the directory and run the build script.
WORKDIR /varnish
RUN ./build-pkg.sh $VERSION $CUSTOM_VER

# Take the 
VOLUME output
COPY export.sh /
ENTRYPOINT ["/bin/bash", "/export.sh"]
