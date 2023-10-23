# syntax = docker/dockerfile:1.3
# VULN_SCAN_TIME=2023-10-16_05:14:00


# The build stage
# ---------------
# This stage is building Python wheels for use in later stages by using a base
# image that has more pre-requisites to do so, such as a C++ compiler.
#
# NOTE: If the image version is updated, also update it in ci/refreeze and
#       hub's Dockerfile!
#
FROM registry.access.redhat.com/ubi8/python-311:1-25.1696515654 as build-stage

# Build wheels
#
# We set pip's cache directory and expose it across build stages via an
# ephemeral docker cache (--mount=type=cache,target=${PIP_CACHE_DIR}). We use
# the same technique for the directory /tmp/wheels.
#
WORKDIR /opt/app-root/src
COPY requirements.txt requirements.txt
ARG PIP_CACHE_DIR=/tmp/pip-cache
RUN --mount=type=cache,target=${PIP_CACHE_DIR} \
    pip install --no-cache-dir --upgrade pip==23.3.* \
    && pip install --no-cache-dir build==1.0.* \
    && pip wheel \
    --wheel-dir=/tmp/wheels \
    -r requirements.txt


# The final stage
# ---------------
#
FROM registry.access.redhat.com/ubi8/python-311:1-25.1696515654
ENV DEBIAN_FRONTEND=noninteractive

ENV NB_USER=jovyan \
    NB_UID=1000 \
    HOME=/home/jovyan
USER root
RUN adduser \
    --uid ${NB_UID} \
    --home ${HOME} \
    ${NB_USER}

RUN dnf install -y \
    ca-certificates \
    bind-utils-32:9.11.36-8.el8_8.2 \
    iputils-20180629-10.el8 \
    # requirement for nbgitpuller
    git-2.39.3-1.el8_8 \
    && dnf clean all

# install wheels built in the build-stage
COPY requirements.txt /tmp/requirements.txt
ARG PIP_CACHE_DIR=/tmp/pip-cache
RUN --mount=type=cache,target=${PIP_CACHE_DIR} \
    --mount=type=cache,from=build-stage,source=/tmp/wheels,target=/tmp/wheels \
    pip install --no-cache-dir --upgrade pip==23.3.* \
    && pip install --no-cache-dir \
    --find-links=/tmp/wheels/ \
    -r /tmp/requirements.txt

WORKDIR ${HOME}
USER ${NB_USER}

EXPOSE 8888
CMD ["jupyter", "lab"]
