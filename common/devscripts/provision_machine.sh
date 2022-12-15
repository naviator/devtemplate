#!/bin/sh

set -eux

if [ "${EUID:-$(id -u)}" -ne 0 ]; then
    echo "Elevating permissions..."
    if [ command -v sudo ]; then
        sudo su - || echo "Not root, exiting" && exit 0
    else
        echo "sudo not available"
        exit 0
    fi
fi

INSTALL_PACKAGES=${INSTALL_PACKAGES:-"git less zsh"}

if command -v dnf; then
    dnf install -y ${INSTALL_PACKAGES};
    dnf clean all;
elif command -v apt; then
    apt update;
    apt install -y ${INSTALL_PACKAGES};
    rm -rf /var/lib/apt/lists/*;
elif command -v apk; then
    apk add --no-cache ${INSTALL_PACKAGES};
fi
