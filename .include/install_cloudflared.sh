#!/bin/bash
# Kenneth Holmqvist
# kholmqvist88 @ gmail.com
#

function install_cloudflared() {
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
}
