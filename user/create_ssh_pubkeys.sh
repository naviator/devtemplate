#!/bin/bash

set -eu

if kubectl get configmap ${USER_SSH} --no-headers ; then
    echo "${USER_SSH} exists, quitting..."
    exit 0
fi

echo "Uploading SSH public keys..."
SSH_KEYS=${SSH_KEYS:-$HOME/.ssh}

tmpfile=$(mktemp)

for pub_key in $(ls $SSH_KEYS/*.pub); do
    echo "Using $pub_key"
    base=$(basename $pub_key)
    cat $pub_key >> $tmpfile
done

kubectl create configmap ${USER_SSH} --from-file=authorized_keys=$tmpfile

rm "$tmpfile"
