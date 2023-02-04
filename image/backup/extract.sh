#!/bin/sh

set -eux

export BORG_REPO=${BORG_REPO:-"ssh://borg-service/${BACKUP_REMOTE}"}
export BORG_RSH=${BORG_RSH:-"sh -c 'exec socat STDIO TCP:${BACKUP_BORG_SERVICE},connect-timeout=10'"}

export LAST_BACKUP=${LAST_BACKUP:-"$(borg list | cut -d' ' -f1 | tail -n 1)"}

if [ ! -z ${LAST_BACKUP} ]; then
    borg extract ${BORG_REPO}::${LAST_BACKUP} || true
else
    echo "Nothing to restore: no backups available"
fi
