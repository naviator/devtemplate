#!/bin/bash

set -eux

USERNAME=dev
USER_UID=1000
USER_GID=$USER_UID

if id ${USERNAME} &>/dev/null; then
    echo 'user exists, removing'
    userdel ${USERNAME}
fi

if id ${USER_UID} &>/dev/null; then
    echo 'user uid already exists'
    userdel $(id -n -u ${USER_UID})
fi

if grep -q $USER_GID /etc/group; then
    echo 'group exists'
    groupdel $USER_GID
fi

# Create non-root user for development purposes
groupadd --gid $USER_GID $USERNAME \
    && useradd --uid $USER_UID --gid $USER_GID -m $USERNAME --home /data

if grep -q wheel /etc/group; then
    echo 'group wheel exists, adding user'
    usermod -a -G wheel $USERNAME
    if [ -d /etc/sudoers.d ]; then
        echo "%wheel ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/wheel
    fi
fi
