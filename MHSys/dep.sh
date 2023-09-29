#!/bin/bash
function install_dependencies() {
    apt-get install apt-transport-https zip unzip lsb-release curl gnupg -y
}
if [ "$(id -u)" != "0" ]; then
    echo "Este script deve ser executado como root."
    exit 1
fi
install_dependencies
