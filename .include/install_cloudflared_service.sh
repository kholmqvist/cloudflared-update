#!/bin/bash
# Kenneth Holmqvist
# kholmqvist88 @ gmail.com
#

function install_cloudflared_service() {
  # Check if cloudflared service exist else install it
  if ! systemctl restart cloudflared.service | head -c1 | grep -E '.'; then
    if [ -e "$configFile" ]; then
      rm "$configFile"
    fi
    cloudflared service install
  fi
}
