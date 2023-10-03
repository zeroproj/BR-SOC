#!/bin/bash
install_dir="/opt/MHSOC/"
ln -s $install_dir'MHConf/custom-w2thive.py' /var/ossec/integrations/custom-w2thive.py
ln -s $install_dir'MHConf/custom-w2thive' /var/ossec/integrations/custom-w2thive
ln -s /var/ossec/logs/integrations.log $install_dir'logs/integrations.log'
sudo chmod 755 /var/ossec/integrations/custom-w2thive.py
sudo chmod 755 /var/ossec/integrations/custom-w2thive
sudo chown root:wazuh /var/ossec/integrations/custom-w2thive.py
sudo chown root:wazuh /var/ossec/integrations/custom-w2thive

read -p "Digite a chave de API: " api_key
if [ -z "$api_key" ]; then
    echo "A chave de API não pode estar em branco. Saindo."
    exit 1
fi
config_file="/var/ossec/etc/ossec.conf"
if [ ! -f "$config_file" ]; then
    echo "O arquivo $config_file não foi encontrado. Saindo."
    exit 1
fi
sed -i '/<\/ossec_config>/i \
  <integration>\
    <name>custom-w2thive</name>\
    <hook_url>127.0.0.1:9001</hook_url>\
    <api_key>'"$api_key"'</api_key>\
    <alert_format>json</alert_format>\
  </integration>' "$config_file"

  sudo systemctl restart wazuh-manager

  if [ "$(id -u)" != "0" ]; then
    echo "Este script deve ser executado como root."
    exit 1
else
    install_wserver
fi
