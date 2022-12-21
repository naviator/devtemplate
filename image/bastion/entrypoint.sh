#!/bin/sh

set -eux

echo "Backing up environment..."
env > "${HOME}"/.env

HOSTKEY=${HOSTKEY:-/tmp/.sshd.hostkey}
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

mkdir -p "${HOME}/.sshd"
HOSTKEY_PATH="${HOME}/.sshd/id_ed25519"
if [ ! -z ${SSHD_HOSTKEY+x} ]; then
    echo "Copying SSHD host key..."
    echo "${SSHD_HOSTKEY}" > "${HOSTKEY_PATH}"
else
    echo "Generating new SSHD host keys..."
    ssh-keygen -t ed25519 -q -N "" -f "${HOSTKEY_PATH}"
fi

if [ ! -z ${SSH_AUTHORIZED_KEYS+x} ]; then 
    echo "Copying .ssh authorized keys..."
    echo "${SSH_AUTHORIZED_KEYS}" > "${HOME}"/.ssh/authorized_keys
else
    echo "Authorized keys not provided."
fi

SSHD_CONFIG_PATH="${HOME}/.sshd/sshd_config"
cp /etc/ssh/sshd_config_template "${SSHD_CONFIG_PATH}"

cat << EOF >> "${SSHD_CONFIG_PATH}"

HostKey ${HOSTKEY_PATH}
PidFile ${HOME}/.sshd/pid
EOF

echo "Starting SSH server"
exec /usr/sbin/sshd -D -f ${SSHD_CONFIG_PATH} -e
