#!/usr/bin/env bash

# Copyright (c) 2021-2024 tteck
# Author: C S P Nanda (cspnanda)
# License: MIT
# https://github.com/tteck/Proxmox/raw/main/LICENSE

source /dev/stdin <<< "$FUNCTIONS_FILE_PATH"
color
verb_ip6
catch_errors
setting_up_container
network_check
update_os

$STD apt-get install -y \
  wget \
  curl \
  apt-transport-https \
  gpg
wget -qO - https://packages.adoptium.net/artifactory/api/gpg/key/public | gpg --dearmor | tee /etc/apt/trusted.gpg.d/adoptium.gpg > /dev/null
echo "deb https://packages.adoptium.net/artifactory/deb $(awk -F= '/^VERSION_CODENAME/{print$2}' /etc/os-release) main" | tee /etc/apt/sources.list.d/adoptium.list
apt update
apt-get install -y temurin-21-jdk

msg_info "Getting metabase jar"
curl https://downloads.metabase.com/v0.53.8/metabase.jar -o /opt/metabase.jar
msg_ok "Successfully Downloaded metabase jar"

msg_ok "Starting metabase"
cd /opt; java --add-opens java.base/java.nio=ALL-UNNAMED -jar metabase.jar &
msg_ok "Stared metabase"

motd_ssh
customize


msg_info "Cleaning up"
$STD apt-get -y autoremove
$STD apt-get -y autoclean
msg_ok "Cleaned"
