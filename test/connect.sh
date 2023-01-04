#!/bin/sh

kubectl apply -k common
kubectl wait --for=condition=available --timeout=60s deployment bastion
EXPECTED=$(date)
ssh -F .ssh/config bastion-devtemplate "echo -n \"${EXPECTED}\" > /tmp/somedata"
FOUND=$(kubectl exec deployment/bastion -- sh -c "cat /tmp/somedata")

if [ "$EXPECTED" != "$FOUND" ]; then
    echo Mismatch "$EXPECTED" != "$FOUND"
    exit 1
fi

kubectl apply -k develop
sleep 1
kubectl wait --for=condition=available --timeout=60s deployment develop
ssh -F .ssh/config develop.default.svc "echo -n \"${EXPECTED}\" > /tmp/somedata"
FOUND=$(kubectl exec deployment/develop -c main -- sh -c "cat /tmp/somedata")

if [ "$EXPECTED" != "$FOUND" ]; then
    echo Mismatch "$EXPECTED" != "$FOUND"
    exit 1
fi
