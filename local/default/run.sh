#!/bin/bash

set -ex

function start() {
	minikube config set rootless false
	minikube start \
	--kubernetes-version=1.22.11 \
	--driver=podman --container-runtime=cri-o \
	--cpus=6 --memory=7918MB \
	--addons registry --insecure-registry "10.0.0.0/24"
}

function stop() {
	minikube stop
}

if [ "$1" == "stop" ]; then
	stop
elif [ "$1" == "start" ]; then
	start
else
	echo "Please use command start or stop."
	exit 1
fi
