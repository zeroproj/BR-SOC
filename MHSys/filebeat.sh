#!/bin/bash
install_dir="/opt/MHSOC/"
function install_beat() {
    echo -e "- Instalando Pacotes FileBeat"
    apt-get install filebeat=7.17.12
    systemctl daemon-reload
    systemctl enable filebeat
}
function template_beat() {
    echo -e "- Instalando Template FileBeat"
    unlink /etc/filebeat/wazuh-template.json
    ln -s $install_dir'MHConf/wazuh-template45.json' /etc/filebeat/wazuh-template.json
    chmod go+r /etc/filebeat/wazuh-template.json
}
function wserver_beat() {
    echo -e "- Instalando Integracão WServer e FileBeat"
    tar -xvzf $install_dir'MHConf/wazuh-filebeat-0.2.tar.gz' -C /usr/share/filebeat/module
}
function beat_con() {
    echo -e "- Instalando Integracão FileBeat"
    senha_elastic=$(grep 'PASSWORD elastic' $install_dir'MHSocSenha.txt' | awk '{print $NF}')
    sed -i "s/output.elasticsearch.password: <elasticsearch_password>/output.elasticsearch.password: $senha_elastic/g" $install_dir'MHConf/filebeat.yml'
}
function beat_cert() {
    cp -r /etc/elasticsearch/certs/ca/ /etc/filebeat/certs/
    cp /etc/elasticsearch/certs/MHelastic.crt /etc/filebeat/certs/filebeat.crt
    cp /etc/elasticsearch/certs/MHelastic.key /etc/filebeat/certs/filebeat.key
}
function start_filebeat() {
    systemctl start filebeat
}

if [ "$(id -u)" != "0" ]; then
    echo "Este script deve ser executado como root."
    exit 1
else
    install_beat
    template_beat
    wserver_beat
    beat_con
    beat_cert
    start_filebeat
fi