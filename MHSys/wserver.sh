#!/bin/bash
install_dir="/opt/MHSOC/"
function install_wserver() {
    echo -e "- Instalando Pacotes WServer"
    apt-get install wazuh-manager
    systemctl daemon-reload
    systemctl enable wazuh-manager
    systemctl start wazuh-manager
}

if [ "$(id -u)" != "0" ]; then
    echo "Este script deve ser executado como root."
    exit 1
else
    install_wserver
fi