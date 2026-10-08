#!/bin/bash
set -euo pipefail
export DEBIAN_FRONTEND=noninteractive
PACKAGES="${PACKAGES:-vim git tmux}"

echo "===== Kernel antes: $(uname -r) ====="
apt-get update
apt-get -y -o Dpkg::Options::=--force-confdef -o Dpkg::Options::=--force-confold full-upgrade
apt-get -y install $PACKAGES
apt-get -y autoremove --purge
apt-get clean
echo "===== Parches y paquetes aplicados ====="
