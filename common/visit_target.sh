#!/bin/sh

if [ -f "${HOME}/.env" ]; then
    cat "${HOME}/.env" | grep -E "^SLEEP_COMMAND=|^TARGET_SHELL=" > "${HOME}/.env.filtered"
    source "${HOME}/.env.filtered"
fi

if [ -n "${SSH_CONNECTION}" ] ; then
    SLEEP_COMMAND=${SLEEP_COMMAND:-'tail -f /dev/null'}
    TARGET_PID=$(cat /tmp/.pid)
    UID=$(cat /tmp/.runas | cut -d':' -f1)
    GID=$(cat /tmp/.runas | cut -d':' -f2)
    
    if [ $# -eq 0 ]; then
        TARGET_COMMAND=${TARGET_SHELL:-sh}
    else
        TARGET_COMMAND="$@"
    fi

    if [ -n "${SSH_AUTH_SOCK}" ]; then
        chown $UID:$GID -R $(dirname "${SSH_AUTH_SOCK}")
    else
        echo "=============================="
        echo "Warning: SSH_AUTH_SOCK not set"
        echo "=============================="
    fi

    exec nsenter -t ${TARGET_PID} -m -u -p -S ${UID} -G ${GID} \
        sh -c "unset HOME USER LOGNAME MAIL SHELL; export HOME=/data; export UID=${UID}; ${TARGET_COMMAND}"
else
    echo "Welcome to SSH sidecar"
fi
