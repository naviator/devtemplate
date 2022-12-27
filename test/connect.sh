#!/bin/sh

EXPECTED=$(date)
ssh -F .ssh/config bastion-host "echo -n ${EXPECTED} > /tmp/somedata"
FOUND=$(kubectl exec deployment/bastion -- sh -c "cat /tmp/somedata")

if [ "$EXPECTED" != "$FOUND" ]; then
    echo Mismatch "$EXPECTED" != "$FOUND"
    exit 1
fi

kubectl apply -k develop
kubectl wait --for=condition=available --timeout=20s deployment develop
ssh -F .ssh/config develop.default "echo -n ${EXPECTED} > /tmp/somedata"
FOUND=$(kubectl exec deployment/develop -c main -- sh -c "cat /tmp/somedata")

if [ "$EXPECTED" != "$FOUND" ]; then
    echo Mismatch "$EXPECTED" != "$FOUND"
    exit 1
fi
