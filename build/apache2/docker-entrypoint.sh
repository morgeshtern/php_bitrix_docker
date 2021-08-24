#!/bin/bash

set -e

cat /etc/hosts |sed  "s/^$(hostname -i).*/$(hostname -i)\t$(hostname) $(hostname).localdomain/" > /tmp/hosts
cat /tmp/hosts > /etc/hosts

exec "$@"