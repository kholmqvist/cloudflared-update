#!/bin/bash
# Kenneth Holmqvist
# kholmqvist88 @ gmail.com
# October 14th 2022
#

# Include dependencies check
for i in .include/*.sh;
  do source $i
done

set -e

# Variables
os=""
configFile="/etc/cloudflared/config.yml"


# Check if i'm root otherwise exit
if [ "$(whoami)" != "root" ]; then
  echo "Please run as root or use sudo"
  exit
fi


# Check if this is a supported linux distribution
check_distribution


# Check if curl is installed
check_curl

# Install Cloudflared
install_cloudflared

# Check if config.yaml or config.yml exists
if [ ! -e /etc/cloudflared/config.yaml ] || [ ! -e /etc/cloudflared/config.yml ]; then
  exit
fi

if [ ! -e "$HOME"/.cloudflared/config.yaml ] || [ ! -e "$HOME"/.cloudflared/config.yml ]; then
  exit
fi

if [ ! -e /usr/local/etc/cloudflared/config.yaml ] || [ ! -e /usr/local/etc/cloudflared/config.yml ]; then
  exit
fi

# Install cloudflared service
install_cloudflared_service

# Restart the cloudflared service
systemctl restart cloudflared.service
