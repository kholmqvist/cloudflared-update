#!/bin/bash
# Kenneth Holmqvist
# kholmqvist88 @ gmail.com
#

# Check if curl is installed
function check_curl () {
if ! command -v curl &> /dev/null ; then
  echo "curl is not installed!"
  
  if [ "$os" == "centos" ]; then
    echo "Please run: yum install curl"
  fi

  if [ "$os" == "debian" ]; then
    echo "Please run: apt install curl"
  fi

  if [ "$os" == "redhat" ]; then
    echo "Please run: yum install curl"
  fi

  if [ "$os" == "ubuntu" ]; then
    echo "Please run: apt install curl"
  fi

  exit
fi
}
