#!/bin/sh

set -eux

env | grep -v "^HOME=" > /data/.env
chmod --reference=/data/ /data/.env

DEV_UID=$(cat /tmp/.runas | cut -d':' -f1)

su $(id -nu ${DEV_UID}) -c "tail -f /dev/null & echo \$! > /tmp/.pid"

date > /tmp/.started

# no need to log anymore
set +x
while [ -d /proc/$(cat /tmp/.pid) ]
do
    sleep 1s
done
