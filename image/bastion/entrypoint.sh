#!/bin/sh

echo "Generating SSHD server keys..."
ssh-keygen -A

echo "Starting SSH server"
/usr/sbin/sshd -D -E /var/log/sshd.log
