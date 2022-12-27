#!/bin/sh

set -eux

if [ "${EUID:-$(id -u)}" -ne 0 ]; then
    echo "Elevating permissions..."
    if command -v sudo; then
        sudo su - || echo "Not root, exiting" && exit 0
    else
        echo "sudo not available"
        exit 0
    fi
fi

############
# PACKAGES #
############
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

########
# USER #
########

DEV_UID=$(cat /tmp/.runas | cut -d':' -f1)
DEV_GID=$(cat /tmp/.runas | cut -d':' -f2)

if [ ${DEV_UID} -eq 0 ]; then
    echo "Running as root"
    exit 0
fi

DEV_USERNAME=dev

if id -n ${DEV_UID} >/dev/null 2>&1; then
    echo 'user uid already exists'
    exit 0
fi

if grep -q ${DEV_GID} /etc/group; then
    echo 'group exists'
    groupdel ${DEV_GID}
fi

# Create non-root user for development purposes
groupadd --gid ${DEV_GID} dev \
    && useradd --uid ${DEV_UID} --gid ${DEV_GID} -m dev --home /data

if grep -q wheel /etc/group; then
    echo 'group wheel exists, adding user'
    if command -v usermod; then
        usermod -a -G wheel $(id -nu)
    elif command -v addgroup; then
        addgroup $(id -nu) wheel
    fi

    if [ -d /etc/sudoers.d ]; then
        echo "%wheel ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/wheel
    fi
fi
