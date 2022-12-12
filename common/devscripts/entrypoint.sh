#!/bin/bash

set -eux

env > /data/.env
date > /tmp/started
exec tail -f /dev/null
