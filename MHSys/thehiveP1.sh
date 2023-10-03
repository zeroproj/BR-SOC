#!/bin/bash
install_dir="/opt/MHSOC/"
function install_cassandra() {
    echo -e "- Instalando Pacotes Cassandra"
    sudo apt install cassandra
    if [ $? -eq 0 ]; then
        echo "- Cassandra: Instalado com sucesso"
        CQLSH_CMD="cqlsh"
        $CQLSH_CMD -f $install_dir'MHConf/atualizar_cluster.cql'
        nodetool flush
        if [ $? -eq 0 ]; then
            echo "- Cassandra: Iniciado com sucesso"
        else
            echo "- Cassandra: Erro ao iniciar o Wazuh"
            exit 600
        fi
    else
        echo "- Cassandra: Erro ao instalar o Wazuh"
        exit 600
    fi     
}
sed -i "s/cluster_name: 'Test Cluster'/cluster_name: 'thp'/" /etc/cassandra/cassandra.yaml
sed -i "s/^# hints_directory: \/var\/lib\/cassandra\/hints/hints_directory: \/var\/lib\/cassandra\/hints/" /etc/cassandra/cassandra.yaml
systemctl restart cassandra
mkdir -p /opt/thp/thehive/index
mkdir -p /opt/thp/thehive/files
mkdir -p /opt/thp/thehive/database


sudo apt-get install thehive4
chown thehive:thehive /opt/thp/thehive/index
chown thehive:thehive /opt/thp/thehive/files
chown thehive:thehive /opt/thp/thehive/database
unlink /etc/thehive/application.conf
rm /etc/thehive/application.conf
ln -s $install_dir'MHConf/application.conf' /etc/thehive/application.conf
chown thehive:thehive /etc/thehive/application.conf
systemctl restart thehive
pip install thehive4py


if [ "$(id -u)" != "0" ]; then
    echo "Este script deve ser executado como root."
    exit 1
else
    install_wserver
fi


/etc/thehive/application.conf