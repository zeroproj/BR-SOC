#!/bin/bash
install_dir="/opt/MHSOC/"
function install_kibana() {
    echo -e "- Instalando Pacotes Kibana"
    apt-get install kibana=7.17.12
    systemctl daemon-reload
    systemctl enable kibana
}
function kibana_cert() {
    mkdir /etc/kibana/certs/ca -p
    cp -R /etc/elasticsearch/certs/ca/ /etc/kibana/certs/
    cp /etc/elasticsearch/certs/MHelastic.key /etc/kibana/certs/kibana.key
    cp /etc/elasticsearch/certs/MHelastic.crt /etc/kibana/certs/kibana.crt
    chown -R kibana:kibana /etc/kibana/
    chmod -R 500 /etc/kibana/certs
    chmod 440 /etc/kibana/certs/ca/ca.* /etc/kibana/certs/kibana.*
}

function kibana_con() {
    echo -e "- Instalando Integracão Kibana"
    unlink /etc/kibana/kibana.yml
    echo -e "- Instalando Integracão Kibana"
    senha_elastic=$(grep 'PASSWORD elastic' $install_dir'MHSocSenha.txt' | awk '{print $NF}')
    sed -i "s/elasticsearch.password: <elasticsearch_password>/elasticsearch.password: $senha_elastic/g" $install_dir'MHConf/kibana.yml'
    ln -s $install_dir'MHConf/kibana.yml' /etc/kibana/kibana.yml
}

function kibana_plugin() {
    mkdir /usr/share/kibana/data
    chown -R kibana:kibana /usr/share/kibana
    cd /usr/share/kibana
    sudo -u kibana /usr/share/kibana/bin/kibana-plugin install file:$install_dir'MHConf/wazuh_kibana-4.5.2_7.17.12-1.zip'
    setcap 'cap_net_bind_service=+ep' /usr/share/kibana/node/bin/node
}
function start_kibana() {
    systemctl start kibana
}

if [ "$(id -u)" != "0" ]; then
    echo "Este script deve ser executado como root."
    exit 1
else
    install_kibana
    kibana_cert
    kibana_con
    kibana_plugin
    start_kibana
fi