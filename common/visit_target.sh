#!/bin/sh

if [ -f "${HOME}/.env" ]; then
    cat "${HOME}/.env" | grep -E "^SLEEP_COMMAND=|^TARGET_SHELL=" > "${HOME}/.env.filtered"
    source "${HOME}/.env.filtered"
fi

if [ ! -n "${SSH_CONNECTION}" ] ; then
    echo "Welcome to SSH sidecar"
    exit 0
fi

SLEEP_COMMAND=${SLEEP_COMMAND:-'tail -f /dev/null'}
TARGET_PID=$(cat /tmp/.pid)
TARGET_UID=$(cat /tmp/.runas | cut -d':' -f1)
TARGET_GID=$(cat /tmp/.runas | cut -d':' -f2)

if [ $# -eq 0 ]; then
    TARGET_COMMAND=${TARGET_SHELL:-sh}
else
    TARGET_COMMAND="$@"
fi

if [ -n "${SSH_AUTH_SOCK}" ]; then
    chown ${TARGET_UID}:${TARGET_GID} -R $(dirname "${SSH_AUTH_SOCK}")
else
    echo "=============================="
    echo "Warning: SSH_AUTH_SOCK not set"
    echo "=============================="
fi

# Containers in pod already share Network and IPC namespace.
# Not sharing user namespace - main & gate containers might have different set of users.
exec nsenter --target ${TARGET_PID} \
    --mount --uts --pid --cgroup --setuid ${TARGET_UID} --setgid ${TARGET_GID} --time \
    /bin/sh -c "unset HOME USER LOGNAME MAIL SHELL; export HOME=/data; export UID=${TARGET_UID}; ${TARGET_COMMAND}"
