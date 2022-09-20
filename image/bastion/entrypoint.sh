#!/bin/sh

set -eux

echo "Generating SSHD server keys..."
mkdir -m 700 -p ${HOME}/.sshd
HOSTKEY=${HOME}/.sshd/hostkey
if [ ! -f ${HOSTKEY} ]; then
    ssh-keygen -t ed25519 -q -N "" -f ${HOSTKEY}
fi

echo "Creating .ssh folder..."
mkdir -m 700 -p ${HOME}/.ssh
AUTHORIZED_KEYS_PATH=${AUTHORIZED_KEYS_PATH:-/usr/ssh/authorized_keys}
if [ -f ${AUTHORIZED_KEYS_PATH} ]; then
    cp ${AUTHORIZED_KEYS_PATH} ${HOME}/.ssh/authorized_keys
    chmod 644 ${HOME}/.ssh/authorized_keys
fi
chown ${USER}:${USER} -R ${HOME}/.ssh/

echo "Starting SSH server"
SSHD_CONFIG_PATH=${SSHD_CONFIG_PATH:-/etc/ssh/sshd_config}

echo "Cloning config..."
NEW_CONFIG=${HOME}/.sshd/sshd_config
cp ${SSHD_CONFIG_PATH} ${NEW_CONFIG}
SSHD_CONFIG_PATH=${NEW_CONFIG}
chmod 644 ${SSHD_CONFIG_PATH}

echo "HostKey ${HOSTKEY}" >> ${SSHD_CONFIG_PATH}
echo "Port 2222" >> ${SSHD_CONFIG_PATH}
echo "PidFile ${HOME}/.sshd/sshd.pid" >> ${SSHD_CONFIG_PATH}

env > ${HOME}/.env

exec /usr/sbin/sshd -D -f ${SSHD_CONFIG_PATH} -e
