# Determine which base image to grab.
ARG BASE_IMG=ubuntu:lts

FROM ${BASE_IMG}

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive
ENV DEBFULLNAME=Jiannis
ENV DEBEMAIL=email@example.com
ENV REL=noble
ENV ARCH=amd64

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

# Get version and custom version later, as the previous steps will always be
# the same and we can benefit from Docker's caching.
ARG VERSION=
ARG CUSTOM_VER=

# Copy over the necessary assets.
COPY debian /varnish/debian/
COPY build-pkg.sh /varnish/
COPY dl-source.sh /varnish/
COPY export.sh /

# Switch to the directory and run the build script.
WORKDIR /varnish
RUN ./build-pkg.sh $VERSION $CUSTOM_VER

# Take the built package and put it in the output volume.
ENTRYPOINT ["/bin/bash", "/export.sh"]
