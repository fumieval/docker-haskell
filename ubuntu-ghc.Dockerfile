FROM ubuntu:18.04
LABEL author="Fumiaki Kinoshita <fumiexcel@gmail.com>"
# Based on https://github.com/phadej/docker-haskell-example

# Update APT
RUN apt-get -yq update && apt-get -yq upgrade

# hvr-ppa, provides GHC and cabal-install
RUN apt-get -yq --no-install-suggests --no-install-recommends install \
    software-properties-common \
    apt-utils \
  && apt-add-repository -y "ppa:hvr/ghc"

# Locales
# - UTF-8 is good
RUN apt-get -yq --no-install-suggests --no-install-recommends install \
    locales

RUN locale-gen en_US.UTF-8
ENV LANG=en_US.UTF-8
ENV LANGUAGE=en_US:en
ENV LC_ALL=en_US.UTF-8

# Some what stable dependencies
# - separately, mostly to spot ghc and cabal-install
RUN apt-get -yq --no-install-suggests --no-install-recommends install \
    cabal-install-3.0 \
    ghc-8.8.2

# More dependencies, all the -dev libraries
# - some basic collection of often needed libs
# - also some dev tools
RUN apt-get -yq --no-install-suggests --no-install-recommends install \
    build-essential \
    ca-certificates \
    curl \
    git \
    libgmp-dev \
    liblapack-dev \
    liblzma-dev \
    libpq-dev \
    libssl-dev \
    libyaml-dev \
    netbase \
    openssh-client \
    pkg-config \
    zlib1g-dev \
    upx

# Set up PATH
ENV PATH=/cabal/bin:/opt/ghc/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
