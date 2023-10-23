# syntax = docker/dockerfile:1.3
# VULN_SCAN_TIME=2023-10-16_05:13:59


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
WORKDIR /opt/app-root/src

COPY requirements.txt requirements.txt
ARG PIP_CACHE_DIR=/tmp/pip-cache
RUN --mount=type=cache,target=${PIP_CACHE_DIR} \
    pip install --no-cache-dir --upgrade pip==23.3.* \
    # Figure out how to manage build and pip dependency
    && pip install --no-cache-dir build==1.0.3 \
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
    --uid "${NB_UID}" \
    --home-dir "${HOME}" \
    --shell /bin/bash \
    "${NB_USER}"

RUN dnf install -y --nodocs libcurl-7.61.1-30.el8_8.3 \
    libpq-13.5-1.el8 \
    sqlite-3.26.0-18.el8_8 \
    && dnf clean all

# install wheels built in the build stage
COPY requirements.txt /tmp/requirements.txt
ARG PIP_CACHE_DIR=/tmp/pip-cache
RUN --mount=type=cache,target=${PIP_CACHE_DIR} \
    --mount=type=cache,from=build-stage,source=/tmp/wheels,target=/tmp/wheels \
    pip install --no-cache-dir --upgrade pip==23.3.* \
    && pip install \
    --no-cache-dir \
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
    --no-cache-dir \
    --find-links=/tmp/wheels/ \
    # Updates below should be repeated in build-stage.
    #
    # py-spy is useful for profiling performance of running hubs
    py-spy

RUN dnf install -y --nodocs curl-7.61.1-30.el8_8.3 \
    bind-utils-32:9.11.36-8.el8_8.2 \
    git-2.39.3-1.el8_8 \
    less-530-1.el8 \
    vim-common-2:8.0.1763-19.el8_6.4 \
    vim-enhanced-2:8.0.1763-19.el8_6.4 \
    && dnf clean all

USER ${NB_USER}
