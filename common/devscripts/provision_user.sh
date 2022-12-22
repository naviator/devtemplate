#!/bin/sh

set -eux

DEV_UID=$(cat /tmp/.runas | cut -d':' -f1)
DEV_GID=$(cat /tmp/.runas | cut -d':' -f2)

if [ ${DEV_UID} -eq 0 ]; then
    echo "Running as root"
    exit 0
fi

DEV_USERNAME=dev

if id -u ${DEV_USERNAME} >/dev/null 2>&1; then
    echo 'user exists, removing'
    userdel ${DEV_USERNAME}
fi

if id -n ${DEV_UID} >/dev/null 2>&1; then
    echo 'user uid already exists'
    userdel $(id -n -u ${DEV_UID})
fi

if grep -q ${DEV_GID} /etc/group; then
    echo 'group exists'
    groupdel ${DEV_GID}
fi

# Create non-root user for development purposes
groupadd --gid ${DEV_GID} ${DEV_USERNAME} \
    && useradd --uid ${DEV_UID} --gid ${DEV_GID} -m ${DEV_USERNAME} --home /data

if grep -q wheel /etc/group; then
    echo 'group wheel exists, adding user'
    usermod -a -G wheel ${DEV_USERNAME}
    if [ -d /etc/sudoers.d ]; then
        echo "%wheel ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/wheel
    fi
fi
