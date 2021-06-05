#!/usr/bin/env bash

set -u

source ".env"

EXECUTABLE="$1"

cat <<EOT
# syntax = docker/dockerfile:experimental

FROM fumieval/ubuntu-ghc:$UBUNTU_VER-$GHC_VER as builder

WORKDIR /build

COPY docker.cabal.config /build/cabal.config
ENV CABAL_CONFIG /build/cabal.config

RUN cabal update

RUN cabal install cabal-plan \\
  --constraint='cabal-plan ^>=0.7' \\
  --constraint='cabal-plan +exe' \\
  --installdir=/usr/local/bin

COPY *.cabal /build/
RUN --mount=type=cache,target=dist-newstyle cabal build --only-dependencies

COPY . /build

RUN --mount=type=cache,target=dist-newstyle cabal build exe:$EXECUTABLE \\
  && mkdir -p /build/artifacts && cp \$(cabal-plan list-bin exe:$EXECUTABLE) /build/artifacts/

RUN upx /build/artifacts/$EXECUTABLE

FROM ubuntu:$UBUNTU_VER

RUN apt-get -yq update && apt-get -yq --no-install-suggests --no-install-recommends install \\
    ca-certificates \\
    curl \\
    libgmp10 \\
    liblzma5 \\
    libssl1.1 \\
    libyaml-0-2 \\
    netbase \\
    zlib1g \\
  && apt-get clean \\
  && rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY --from=builder /build/artifacts/$EXECUTABLE /app/$EXECUTABLE

ENTRYPOINT ["./$EXECUTABLE"]
EOT