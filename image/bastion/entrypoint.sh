#!/bin/sh

set -eux

echo "Backing up environment..."
env > "${HOME}"/.env

HOSTKEY=${HOSTKEY:-"${HOME}"/.sshd/hostkey}
if [ ! -f "${HOSTKEY}" ]; then
    echo "Generating SSHD server keys..."
    HOSTKEY_PARENT=$(dirname "${HOSTKEY}")
    if [ ! -d "${HOSTKEY_PARENT}" ]; then
        mkdir -m 700 -p "${HOSTKEY_PARENT}"
    fi
    ssh-keygen -t ed25519 -q -N "" -f "${HOSTKEY}"
fi

if [ ! -d "${HOME}"/.ssh ]; then
    echo "Creating .ssh folder..."
    mkdir -m 700 -p "${HOME}"/.ssh
fi

if [ ! -z ${USER_SSH_CONTENT+x} ]; then 
    echo "Copying USER SSH content"
    rsync -rLv "${USER_SSH_CONTENT}/" "${HOME}"/.ssh/
fi

echo "Starting SSH server"
SSHD_CONFIG_PATH=${SSHD_CONFIG_PATH:-/etc/ssh/sshd_config_override}
exec /usr/sbin/sshd -D -f ${SSHD_CONFIG_PATH} -e
