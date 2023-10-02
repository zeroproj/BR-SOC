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
            exit 200
        fi
    else
        echo "- Cassandra: Erro ao instalar o Wazuh"
        exit 200
    fi     
}

if [ "$(id -u)" != "0" ]; then
    echo "Este script deve ser executado como root."
    exit 1
else
    install_wserver
fi