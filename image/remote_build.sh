#!/bin/bash

set -eux

CONTAINER_USER=${CONTAINER_USER:-dev}
CONTAINER_UID=${CONTAINER_UID:-1000}

if [ $# -eq 0 ]; then
	echo "No arguments supplied..."	
	exit 1
fi

if [ ! -d $1 ]; then
	echo "Directory does not exist"
	exit 1
fi

IMAGE=$1
BUILD_ROOT=/tmp
TAG=registry:5001/${IMAGE} 

POD=$(kubectl get pod -l app=image-builder -o jsonpath="{.items[0].metadata.name}")

kubectl cp ${IMAGE} ${POD}:${BUILD_ROOT}/ -c main
kubectl cp devuser.sh ${POD}:${BUILD_ROOT}/${IMAGE}/ -c main

ssh image-builder.default /etc/profile "podman build -f Containerfile \
    --ssh default \
    -t ${TAG} \
    --build-arg USERNAME=${CONTAINER_USER} \
    --build-arg USER_UID=${CONTAINER_UID} \
    ${BUILD_ROOT}/${IMAGE} && /etc/profile podman push ${TAG}"
