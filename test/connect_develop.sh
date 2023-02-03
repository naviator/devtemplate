#!/bin/sh

set -eux

kubectl apply -k common
kubectl apply -k develop
kubectl wait --for=condition=available --timeout=60s deployment bastion
kubectl wait --for=condition=available --timeout=60s deployment develop

KUBECTL_NAMESPACE=$(kubectl config view --minify | grep namespace | cut -d" " -f6)
NAMESPACE=${KUBECTL_NAMESPACE:-"default"}

EXPECTED=$(date)
ssh -F .ssh/config develop.${NAMESPACE}.svc "echo -n \"${EXPECTED}\" > /tmp/somedata"
FOUND=$(kubectl exec deployment/develop -c main -- sh -c "cat /tmp/somedata")

if [ "$EXPECTED" != "$FOUND" ]; then
    echo Mismatch "$EXPECTED" != "$FOUND"
    exit 1
fi
