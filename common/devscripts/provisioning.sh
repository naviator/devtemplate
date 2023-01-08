#!/bin/sh

set -eux

##############
# PRIVILEGES REQUIRED
##############

if [ "${EUID:-$(id -u)}" -ne 0 ]; then
    echo "Elevating permissions..."
    if command -v sudo; then
        sudo su - || echo "Not root, exiting" && exit 0
    else
        echo "sudo not available"
        exit 0
    fi
fi

DEV_UID=$(cat /tmp/.runas | cut -d':' -f1)
DEV_GID=$(cat /tmp/.runas | cut -d':' -f2)

############
# PACKAGES #
############

install () {
    INSTALL_PACKAGES=${INSTALL_PACKAGES:-"git less zsh"}

    if [ -n "${INSTALL_PACKAGES}" ]; then
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
    fi
}

########
# SUDO #
########

sudo() {
    if grep -q wheel /etc/group; then
        echo "Group wheel exists, adding user if it exists"
        if id -n ${DEV_UID} >/dev/null 2>&1; then
            echo "User with UID ${DEV_UID} exists"
            if command -v usermod; then
                usermod -a -G wheel $(id -nu ${DEV_UID})
            elif command -v addgroup; then
                addgroup $(id -nu ${DEV_UID}) wheel
            fi

            if [ -d /etc/sudoers.d ]; then
                echo "%wheel ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/wheel
            fi
        else
            echo "User ${DEV_UID} does not exist"
        fi
    fi
}

for var in "$@"
do
    echo "Running $var"
    $var
done