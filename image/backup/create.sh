#!/bin/sh

set -eux

export BORG_REPO=${BORG_REPO:-"ssh://borg-service/${BACKUP_REMOTE}"}
export BORG_RSH=${BORG_RSH:-"sh -c 'exec socat STDIO TCP:${BACKUP_BORG_SERVICE},connect-timeout=10'"}

export TIMESTAMP=${TIMESTAMP:-$(date +%F_%H:%M:%S)}

borg init \
--encryption=none \
--make-parent-dirs || true

borg create \
--stats \
ssh://borg-service/${BACKUP_REMOTE}::${TIMESTAMP}-$(hostname) \
. || true

borg prune \
--save-space \
--keep-within=1H \
--keep-daily=5 \
--keep-monthly=6 || true
