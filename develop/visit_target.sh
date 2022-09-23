#!/bin/sh

if [ -f ${HOME}/.env ]; then
    source ${HOME}/.env
fi

if [ -n "${SSH_CONNECTION}" ] ; then
    SLEEP_COMMAND=${SLEEP_COMMAND:-'tail -f /dev/null'}
    TARGET_PID=$(ps -e -o pid,args | grep "${SLEEP_COMMAND}" | grep -v grep | awk '{print $1}')
    UID=$(stat -c "%u %g" /proc/${TARGET_PID}/ | awk '{print $1}')
    GID=$(stat -c "%u %g" /proc/${TARGET_PID}/ | awk '{print $2}')
    
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
        sh -c "unset HOME USER LOGNAME MAIL SHELL; export HOME=/data; ${TARGET_COMMAND}"
else
    echo "Welcome to SSH sidecar"
fi
