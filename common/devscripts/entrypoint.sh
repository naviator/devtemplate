#!/bin/sh

set -eux

env
ENVFILE="/data/.env"

env | grep -v "^HOME=" > "${ENVFILE}"

DEV_UID=$(cat /tmp/.runas | cut -d':' -f1)

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
