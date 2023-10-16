# syntax = docker/dockerfile:1.3
# VULN_SCAN_TIME=2023-09-25_05:13:34


# The build stage
# ---------------
# This stage is building Python wheels for use in later stages by using a base
# image that has more pre-requisites to do so, such as a C++ compiler.
#
# NOTE: If the image version is updated, also update it in ci/refreeze and
#       singleuser-sample's Dockerfile!
#
FROM registry.access.redhat.com/ubi8/python-311:1-25.1696515654 as build-stage

# Build wheels
#
# We set pip's cache directory and expose it across build stages via an
# ephemeral docker cache (--mount=type=cache,target=${PIP_CACHE_DIR}). We use
# the same technique for the directory /tmp/wheels.
#
COPY requirements.txt requirements.txt
ARG PIP_CACHE_DIR=/tmp/pip-cache
RUN --mount=type=cache,target=${PIP_CACHE_DIR} \
    pip install --upgrade pip \
    && pip install build \
    && pip wheel \
    --wheel-dir=/tmp/wheels \
    -r requirements.txt \
    # Additional wheels for default-stage. Updates below should be repeated
    # in default-stage.
    #
    py-spy


# The final stage - slim version
# ------------------------------
# This stage is built and published as jupyterhub/k8s-hub-slim. It is meant to
# provide no non-essential packages.
#
FROM registry.access.redhat.com/ubi8/python-311:1-25.1696515654 as slim-stage

ARG NB_USER=jovyan \
    NB_UID=1000 \
    HOME=/home/jovyan

USER root

RUN useradd \
    --no-create-home \
    --system \
    --uid ${NB_UID} \
    --home-dir ${HOME} \
    --shell /bin/bash \
    ${NB_USER}

RUN yum update -y \
    && yum upgrade -y \
    && yum install -y --setopt=tsflags=nodocs \
    # requirement for pycurl
    libcurl \
    # requirement for using postgres database
    postgresql-libs \
    # requirement for using a local sqlite database
    sqlite \
    # tini not available via yum
    # tini \
    && rm -rf /var/cache/yum/*

# install wheels built in the build stage
COPY requirements.txt /tmp/requirements.txt
ARG PIP_CACHE_DIR=/tmp/pip-cache
RUN --mount=type=cache,target=${PIP_CACHE_DIR} \
    --mount=type=cache,from=build-stage,source=/tmp/wheels,target=/tmp/wheels \
    pip install \
    --find-links=/tmp/wheels/ \
    -r /tmp/requirements.txt

WORKDIR /srv/jupyterhub
RUN chown ${NB_USER}:${NB_USER} /srv/jupyterhub
USER ${NB_USER}

EXPOSE 8081
# tini not available via microdnf
# ENTRYPOINT ["tini", "--"]
CMD ["jupyterhub", "--config", "/usr/local/etc/jupyterhub/jupyterhub_config.py"]


# The final stage - default version
# ---------------------------------
# We add a few non-critical packages on top of the slim version to provide some
# additional utility.
#
FROM slim-stage as default-stage

USER root

ARG PIP_CACHE_DIR=/tmp/pip-cache
RUN --mount=type=cache,target=${PIP_CACHE_DIR} \
    --mount=type=cache,from=build-stage,source=/tmp/wheels,target=/tmp/wheels \
    pip install \
    --find-links=/tmp/wheels/ \
    # Updates below should be repeated in build-stage.
    #
    # py-spy is useful for profiling performance of running hubs
    py-spy

RUN yum update -y \
    && yum upgrade -y \
    && yum install -y --setopt=tsflags=nodocs \
    curl \
    bind-utils \
    git \
    less \
    vim \
    && rm -rf /var/cache/yum/*

USER ${NB_USER}
