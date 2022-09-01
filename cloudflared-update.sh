#!/bin/bash
# Kenneth Holmqvist
# kholmqvist88 @ gmail.com
#

set -e

# Variables
filepath="$HOME"
os=""
package="rpm" # Set default package type to rpm
configFile="/etc/cloudflared/config.yml"

# Check if i'm root otherwise exit
if [ "$(whoami)" != "root" ]; then
  echo "Please run as root! or use sudo"
  exit
fi

# Check OS
if [ -e /etc/redhat-release ]; then
  os="redhat"
fi

if [ -e /etc/centos-release ]; then
  os="redhat"
fi

if [ -e /etc/SuSE-release ]; then
  os="suse"
fi

if [ -e /etc/debian_version ]; then
  os="debian"
  package="deb"
fi

# Exit if OS is not supporte
if [ "$os" = "" ]; then
  echo "This is not a supported distribution"
  exit
fi

# Check if wget is installed
if [ ! -e /usr/bin/wget]; then
  echo "you need to install wget"
  exit
fi

# Determine if we need a RPM or DEB package
if [ "$package" = "rpm" ]; then
  filename="cloudflared-linux-x86_64.rpm"
fi

if [ "$package" = "deb" ]; then
  filename="cloudflared-linux-amd64.deb"
fi

# Delete cloudflared-linux-amd64.deb. It's probably an old version
if [ -f "$filepath/$filename" ]; then
  echo "Deleting: $filename"
  rm "$filepath/$filename"
fi

# If the file doesn't exist then download and install it
if [ ! -f "$filepath/$filename" ]; then
  #use subshell to go to filepath and download the file
  (cd "$filepath" && wget -O "$filename" https://github.com/cloudflare/cloudflared/releases/latest/download/$filename)

  # Install Software on RHEL/Centos
  if [ "$os" = "redhat" ]; then
    yum localinstall -y "$filepath/$filename"
  fi

  if [ "$os" = "debian" ]; then
    dpkg -i "$filepath/$filename"
  fi

  if [ "$os" = "suse" ]; then
    zypper install -y "$filepath/$filename"
  fi
fi


# Check if cloudflared service exist else install it
if ! systemctl restart cloudflared | head -c1 | grep -E '.'; then
  if [ -e "$configFile" ]; then
    rm "$configFile"
  fi
  cloudflared service install
fi


# Restart the cloudflared service
systemctl restart cloudflared.service
