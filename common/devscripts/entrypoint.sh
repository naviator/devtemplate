#!/bin/bash

set -eux

env > ${HOME}/.env
date > /tmp/started
exec tail -f /dev/null
