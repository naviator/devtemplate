#!/bin/bash

set -eux

if [ "$EUID" -ne 0 ]; then
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
    dnf install -y ${INSTALL_PACKAGES}
else
    apt update;
    apt install -y ${INSTALL_PACKAGES}
fi

chsh -s /bin/zsh $(id -nu) || echo "cannot change shell"
