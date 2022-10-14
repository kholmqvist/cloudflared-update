#!/bin/bash
# Kenneth Holmqvist
# kholmqvist88 @ gmail.com
# October 14th 2022
#

# Include dependencies check
. $(pwd)/dependencies.sh

set -e

# Variables
os=""
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
  os="centos"
fi

if [ "$DISTRO" == "Fedora Linux" ]; then
  os="redhat"
fi

if [ "$DISTRO" == "Debian GNU/Linux" ]; then
  os="debian"
fi

if [ "$DISTRO" == "Ubuntu" ]; then
  os="ubuntu"
fi

# Exit if OS is supported
if [ "$os" = "" ]; then
  echo "This is not a supported distribution"
  exit
fi

# Check if curl is installed
check_curl

# Install Software on RHEL/Centos
if [ "$os" = "redhat" ]; then
  # Add cloudflared.repo to /etc/yum.repos.d/
  curl -fsSl https://pkg.cloudflare.com/cloudflared-ascii.repo | sudo tee /etc/yum.repos.d/cloudflared.repo

  #update repo
  sudo yum update

  # install cloudflared
  sudo yum install cloudflared
fi

if [ "$os" = "centos" ]; then
  # This requires dnf config-manager
  # Add cloudflared.repo to config-manager
  sudo dnf config-manager --add-repo https://pkg.cloudflare.com/cloudflared-ascii.repo

  # install cloudflared
  sudo dnf install cloudflared
fi

if [ "$os" = "debian" ]; then
  OS_LEVEL=$(cat /etc/*-release | grep -w VERSION_CODENAME | cut -d= -f2 | tr -d '"')

  if [ "$OS_LEVEL" = "buster" ]; then
    # Add cloudflare gpg key
    sudo mkdir -p --mode=0755 /usr/share/keyrings
    curl -fsSL https://pkg.cloudflare.com/cloudflare-main.gpg | sudo tee /usr/share/keyrings/cloudflare-main.gpg >/dev/null

    # Add this repo to your apt repositories
    echo 'deb [signed-by=/usr/share/keyrings/cloudflare-main.gpg] https://pkg.cloudflare.com/cloudflared buster main' | sudo tee /etc/apt/sources.list.d/cloudflared.list

    # install cloudflared
    sudo apt-get update && sudo apt-get install cloudflared
  fi

  if [ "$OS_LEVEL" = "bullseye" ]; then
    # Add cloudflare gpg key
    sudo mkdir -p --mode=0755 /usr/share/keyrings
    curl -fsSL https://pkg.cloudflare.com/cloudflare-main.gpg | sudo tee /usr/share/keyrings/cloudflare-main.gpg >/dev/null

    # Add this repo to your apt repositories
    echo 'deb [signed-by=/usr/share/keyrings/cloudflare-main.gpg] https://pkg.cloudflare.com/cloudflared bullseye main' | sudo tee /etc/apt/sources.list.d/cloudflared.list

    # install cloudflared
    sudo apt-get update && sudo apt-get install cloudflared
  fi
fi

if [ "$os" = "ubuntu" ]; then
  OS_LEVEL=$(cat /etc/*-release | grep -w VERSION_ID | cut -d= -f2 | tr -d '"')

  if [ "$OS_LEVEL" = "20.04" ]; then
    # Add cloudflare gpg key
    sudo mkdir -p --mode=0755 /usr/share/keyrings
    curl -fsSL https://pkg.cloudflare.com/cloudflare-main.gpg | sudo tee /usr/share/keyrings/cloudflare-main.gpg >/dev/null

    # Add this repo to your apt repositories
    echo 'deb [signed-by=/usr/share/keyrings/cloudflare-main.gpg] https://pkg.cloudflare.com/cloudflared focal main' | sudo tee /etc/apt/sources.list.d/cloudflared.list

    # install cloudflared
    sudo apt-get update && sudo apt-get install cloudflared
  fi

  if [ "$OS_LEVEL" = "22.04" ]; then
    # Add cloudflare gpg key
    sudo mkdir -p --mode=0755 /usr/share/keyrings
    curl -fsSL https://pkg.cloudflare.com/cloudflare-main.gpg | sudo tee /usr/share/keyrings/cloudflare-main.gpg >/dev/null

    # Add this repo to your apt repositories
    echo 'deb [signed-by=/usr/share/keyrings/cloudflare-main.gpg] https://pkg.cloudflare.com/cloudflared jammy main' | sudo tee /etc/apt/sources.list.d/cloudflared.list

    # install cloudflared
    sudo apt-get update && sudo apt-get install cloudflared
  fi
fi


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


# Check if cloudflared service exist else install it
if ! systemctl restart cloudflared.service | head -c1 | grep -E '.'; then
  if [ -e "$configFile" ]; then
    rm "$configFile"
  fi
  cloudflared service install
fi

# Restart the cloudflared service
systemctl restart cloudflared.service
