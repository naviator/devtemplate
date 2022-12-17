#!/bin/sh

set -eux

echo "Backup environment..."
env > ${HOME}/.env

echo "Generating SSHD server keys..."
HOSTKEY=${HOSTKEY:-${HOME}/.sshd/hostkey}
if [ ! -f ${HOSTKEY} ]; then
    HOSTKEY_PARENT=$(dirname "${HOSTKEY}")
    if [ ! -d ${HOSTKEY_PARENT} ]; then
        mkdir -m 700 -p ${HOSTKEY_PARENT}
    fi
    ssh-keygen -t ed25519 -q -N "" -f ${HOSTKEY}
fi

echo "Creating .ssh folder..."
if [ ! -d ${HOME}/.ssh ]; then
    mkdir -m 700 -p ${HOME}/.ssh
fi

echo "Starting SSH server"
SSHD_CONFIG_PATH=${SSHD_CONFIG_PATH:-/etc/ssh/sshd_config_override}
exec /usr/sbin/sshd -D -f ${SSHD_CONFIG_PATH} -e
