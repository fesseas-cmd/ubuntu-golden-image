#!/bin/bash
set -eu
echo "===== Limpieza final ====="
rm -f /etc/cloud/cloud.cfg.d/99-installer.cfg \
      /etc/cloud/cloud.cfg.d/90-installer-network.cfg \
      /etc/cloud/cloud.cfg.d/subiquity-disable-cloudinit-networking.cfg
rm -f /etc/netplan/50-cloud-init.yaml
cloud-init clean --logs
truncate -s 0 /etc/machine-id
rm -f /var/lib/dbus/machine-id && ln -s /etc/machine-id /var/lib/dbus/machine-id
rm -f /etc/ssh/ssh_host_*
find /var/log -type f -exec truncate -s 0 {} \;
rm -rf /tmp/* /var/tmp/*
passwd -l packer
echo "✓ Limpieza completada"
