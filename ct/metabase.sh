#!/usr/bin/env bash
source <(curl -s https://raw.githubusercontent.com/tteck/Proxmox/main/misc/build.func)
# Copyright (c) 2021-2024 tteck
# Author: C S P Nanda(cspnanda)
# License: MIT
# https://github.com/tteck/Proxmox/raw/main/LICENSE

function header_info {
clear
cat <<"EOF"
                | |      | |
  _ __ ___   ___| |_ __ _| |__   __ _ ___  ___
 | '_ ` _ \ / _ \ __/ _` | '_ \ / _` / __|/ _ \
 | | | | | |  __/ || (_| | |_) | (_| \__ \  __/
 |_| |_| |_|\___|\__\__,_|_.__/ \__,_|___/\___|

EOF
}
header_info
echo -e "Loading..."
APP="metabase"
var_disk="4"
var_cpu="1"
var_ram="1024"
var_os="debian"
var_version="12"
var_unprivileged=1
variables
color
catch_errors

function default_settings() {
  CT_TYPE="1"
  PW=""
  CT_ID=$NEXTID
  HN=$NSAPP
  DISK_SIZE="$var_disk"
  CORE_COUNT="$var_cpu"
  RAM_SIZE="$var_ram"
  BRG="vmbr0"
  NET="dhcp"
  GATE=""
  APT_CACHER=""
  APT_CACHER_IP=""
  DISABLEIP6="no"
  MTU=""
  SD=""
  NS=""
  MAC=""
  VLAN=""
  SSH="no"
  VERB="no"
  echo_default
}

function update_script() {
header_info
check_container_storage
check_container_resources
if [[ ! -f /opt/metabase.jar ]]; then
    msg_error "No ${APP} Installation Found!"
    exit
fi
msg_info "Updating ${APP} LXC"
apt-get update &>/dev/null
apt-get -y upgrade &>/dev/null
msg_ok "Updated Successfully"
exit
}

start
build_container
description

msg_ok "Completed Successfully!\n"
echo -e "${CREATING}${GN}${APP} setup has been successfully initialized!${CL}"
echo -e "${INFO}${YW} Access it using the following URL:${CL}"
echo -e "${TAB}${GATEWAY}${BGN}http://${IP}${CL}"
