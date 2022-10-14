#!/bin/bash
# Kenneth Holmqvist
# kholmqvist88 @ gmail.com
#

function check_distribution() {
  DISTRO=$(cat /etc/*-release | grep -w NAME | cut -d= -f2 | tr -d '"')
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
    os=""
  fi

  if [ "$DISTRO" == "Ubuntu" ]; then
    os="ubuntu"
  fi
}
