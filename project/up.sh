#!/bin/bash

set -eu

if [ $# -eq 0 ]; then
	echo "No arguments supplied..."	
	exit 1
fi

if [ ! -d $1 ]; then
	echo "Directory does not exist"
	exit 1
fi

CONTAINER_USER=${CONTAINER_USER:-root}

cd $1
kubectl apply -k .
sleep 1
echo "Waiting for deployment..."
APP=${1//\//-}
kubectl wait deployment -l app=${APP} --for condition=Available=True --timeout=20s || exit 1

echo ==================================================================
echo Connecting...
echo ==================================================================
ssh ${CONTAINER_USER}@${APP}.default
