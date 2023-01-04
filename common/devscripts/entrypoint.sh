#!/bin/sh

set -eux

DEV_UID=$(cat /tmp/.runas | cut -d':' -f1)
DEV_GID=$(cat /tmp/.runas | cut -d':' -f2)

# Restore data

echo "Restoring default volumes"
DEFAULT_VOLUME="/default-volume"
if [ -d ${DEFAULT_VOLUME} ]; then
    for ENTRY in $(ls -A ${DEFAULT_VOLUME}); do
        TARGET_PATH="/${ENTRY}"
        if [ -z "$(ls -A ${TARGET_PATH})" ]; then
            echo "Constructing default ${TARGET_PATH}"
            cp -R ${DEFAULT_VOLUME}/${ENTRY} ${TARGET_PATH}
            if [ "${DEV_UID}" -ne $(id -u) ]; then
                chown -R ${DEV_UID}:${DEV_GID} ${TARGET_PATH}
            fi
        else
            echo "${TARGET_PATH} not empty, skipping..."
        fi
    done
fi

# Run

ENVFILE="/data/.env"
# owner does not matter, just has to be readable
env | grep -vE "^HOME=|^UID=" > "${ENVFILE}"

if [ "${DEV_UID}" -eq $(id -u) ]; then
    tail -f /dev/null &
    echo $! > /tmp/.pid
else
    if [ ! -r "${ENVFILE}" ]; then
        chmod u+r "${ENVFILE}"
    fi
    su $(id -nu ${DEV_UID}) -c "tail -f /dev/null & echo \$! > /tmp/.pid"
fi

# no need to log anymore
set +x
while [ -d /proc/$(cat /tmp/.pid) ]
do
    sleep 1s
done
