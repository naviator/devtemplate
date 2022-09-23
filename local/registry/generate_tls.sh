#!/bin/bash

set -eux

echo "Current KUBECONFIG: ${KUBECONFIG}"
REGISTRY_TLS="registry-tls"

kubectl wait node -l node-role.kubernetes.io/master=true --for condition=ready --timeout=10s || exit 1

if kubectl get secret ${REGISTRY_TLS} --no-headers ; then
    echo "${REGISTRY_TLS} exists, quitting..."
    exit 0
fi

rm -f client.key client.cert

if [ ! -f client.key ]; then
    echo "Generating openssl key..."
    openssl genrsa 4096 > client.key
fi

if [ ! -f client.cert ]; then
    echo "Generating openssl cert..."
    cat client.key | openssl req -new -x509 -days 3652 -text -key /dev/stdin \
    -subj "/C=AT/ST=Austria/L=Vienna/O=registry/OU=registry/CN=registry/emailAddress=admin@registry" \
    -addext "subjectAltName = DNS:localhost, DNS:registry" > client.cert
fi

kubectl create secret tls ${REGISTRY_TLS} --cert=client.cert --key=client.key
rm client.key client.cert
