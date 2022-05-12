#!/bin/bash

echo -n "Starting as user: "
id

env > /tmp/env

PACKAGES="openssh-server git vim zsh"

if command -v dnf; then
    dnf install -y ${PACKAGES}
else
    apt update;
    apt install -y ${PACKAGES}
fi

mkdir -p /run/sshd;
echo "PermitUserEnvironment=yes" > /etc/ssh/sshd_config.d/user_env_config;
echo "Generating SSHD server keys..."
ssh-keygen -A
echo "Starting SSH server...";
/usr/sbin/sshd;
echo "Server started, sleeping..."
sleep infinity
