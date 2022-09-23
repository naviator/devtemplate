#!/bin/bash
set -eu

USERNAME=${USERNAME:-dev}
USER_UID=${USER_UID:-1000}
USER_GID=$USER_UID

INSTALL_PACKAGES="sudo git vim make openssh-server"

# Create non-root user for development purposes
groupadd --gid $USER_GID $USERNAME \
    && useradd --uid $USER_UID --gid $USER_GID -m $USERNAME --home /data \

if ! command -v "sudo"; then
    if command -v "dnf" ]; then
        dnf install -y ${INSTALL_PACKAGES}
    elif command -v "apt-get" ]; then
        apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y ${INSTALL_PACKAGES}
    fi
fi

echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME \
    && chmod 0440 /etc/sudoers.d/$USERNAME
