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
DISTRO=$(cat /etc/*-release | grep -w NAME | cut -d= -f2 | tr -d '"')

# Check if i'm root otherwise exit
if [ "$(whoami)" != "root" ]; then
  echo "Please run as root or use sudo"
  exit
fi

# Check OS
if [ "$DISTRO" == "Red Hat Enterprise Linux" ]; then
  os="redhat"
fi

if [ "$DISTRO" == "CentOS Stream" ]; then
  os="redhat"
fi

if [ "$DISTRO" == "Fedora Linux" ]; then
  os="redhat"
fi

if [ "$DISTRO" == "SLES" ]; then
  os="suse"
fi

if [ "$DISTO" == "Debian GNU/Linux" ]; then
  os="debian"
  package="deb"
fi

if [ "$DISTRO" == "Ubuntu" ]; then
  os="debian"
  package="deb"
fi

# Exit if OS is supported
if [ "$os" = "" ]; then
  echo "This is not a supported distribution"
  exit
fi

# Check if wget is installed
if [ ! -e $(which wget) ]; then
  echo "wget is not installed!"
  if [ "$os" == "redhat" ]; then
    echo "Please run: yum install wget"
  fi

  if [ "$os" == "suse" ]; then
    echo "Please run: zypper install wget"
  fi

  if [ "$os" == "debian" ]; then
    echo "Please run: apt install wget"
  fi

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
