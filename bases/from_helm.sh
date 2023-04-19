#!/bin/bash

set -eu

HELM_ARGS="$@"

mkdir ${HELM_REPO_NAME}

if command -v helm; then
    helm repo add ${HELM_REPO_NAME} ${HELM_REPO_URL}
    helm repo update ${HELM_REPO_NAME}
    helm template ${HELM_REPO_NAME} ${HELM_CHART_NAME} --version ${HELM_CHART_VERSION} --namespace ${K8S_NAMESPACE} ${HELM_ARGS} --output-dir ${HELM_REPO_NAME}
else
    if command -v podman; then
        OCI=podman
    elif command -v docker; then
        OCI=docker
    else
        echo "Cannot find docker/podman"
        exit 1
    fi

    ${OCI} run -i --rm --entrypoint "/bin/sh" alpine/helm \
    -c "\
    set -eux; \
    mkdir /target && \
    helm repo add ${HELM_REPO_NAME} ${HELM_REPO_URL} > /dev/null && \
    helm repo update ${HELM_REPO_NAME} > /dev/null && \
    helm template ${HELM_REPO_NAME} ${HELM_CHART_NAME} \
    --version ${HELM_CHART_VERSION} --namespace ${K8S_NAMESPACE} \
    ${HELM_ARGS} \
    --output-dir /target \
    > /dev/null && \
    cd /target && tar cvf - . \
    " | tar -xv -C ${HELM_REPO_NAME}
fi
