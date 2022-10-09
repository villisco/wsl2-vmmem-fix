#!/bin/bash
SYSCTL_CONF="/etc/sysctl.conf"

# run this as root user
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root!"
   exit 1
fi

echo "Current swappiness:"
sysctl -a | grep -i swap
echo ""

# skip re-run
if grep -qE '^vm.swappiness[[:space:]=0-9]+$' $SYSCTL_CONF; then
  echo "Removing already configured swappiness in $SYSCTL_CONF"

  # delete already configured line (other values)
  sed -i '/^vm.swappiness[[:space:]=0-9]*$/d' $SYSCTL_CONF
  echo ""
fi

echo "Disabling swapiness in $SYSCTL_CONF"
echo "vm.swappiness = 0" >> $SYSCTL_CONF
sudo sysctl -p