#!/bin/bash
clear
echo "###########################################################################"
echo "#################                   MHSOC                ##################"
echo "##############           OS: Ubuntu LTS                     ###############"
echo -e "############################################################### MHHSOC ####\n"
P_01="$1" #Parametro 1 - Não Alterar 
dic_temp=/tmp/MHSOC/
EFolder=$(dirname $0)
senha_elastic=""
#Desenvolvido por Lucas Matheus e Gabriel
#################################################
function install_dependencies() {
    apt-get install apt-transport-https zip unzip lsb-release curl gnupg    
}
function install_elasticsearch() {
    echo -e "- Instalando Pacotes Necessarios"
    #Elasticsearch Install
    echo -e "- Configurando Repositorio"
    curl -s https://artifacts.elastic.co/GPG-KEY-elasticsearch | gpg --no-default-keyring --keyring gnupg-ring:/usr/share/keyrings/elasticsearch.gpg --import && chmod 644 /usr/share/keyrings/elasticsearch.gpg
    echo "deb [signed-by=/usr/share/keyrings/elasticsearch.gpg] https://artifacts.elastic.co/packages/7.x/apt stable main" | tee /etc/apt/sources.list.d/elastic-7.x.list
    apt-get update
    echo -e "- Instalando Pacotes Elasticsearch"
    apt-get install elasticsearch=7.17.12
    systemctl daemon-reload
    systemctl enable elasticsearch
}
function config_elasticsearch() {
    echo -e "- Baixando arquivo de configuração Elasticsearch"
    curl -so /etc/elasticsearch/elasticsearch.yml https://raw.githubusercontent.com/zeroproj/MHSoc/main/MHConf/elasticsearch.yml?token=GHSAT0AAAAAACH7RYRWE6J3G6CZVE5MUOMOZIPN55A
}
function config_cert() {
    echo -e "- Baixando arquivo de configuração Certificado"
    curl -so /usr/share/elasticsearch/instances.yml https://raw.githubusercontent.com/zeroproj/MHSoc/main/MHConf/instances.yml?token=GHSAT0AAAAAACH7RYRWBKO2VO55LBIW7GAGZIPO23Q
    /usr/share/elasticsearch/bin/elasticsearch-certutil cert ca --pem --in instances.yml --keep-ca-key --out ~/certs.zip
    unzip ~/certs.zip -d ~/certs
    mkdir /etc/elasticsearch/certs/ca -p
    cp -R ~/certs/ca/ ~/certs/elasticsearch/* /etc/elasticsearch/certs/
    chown -R elasticsearch: /etc/elasticsearch/certs
    chmod -R 500 /etc/elasticsearch/certs
    chmod 400 /etc/elasticsearch/certs/ca/ca.* /etc/elasticsearch/certs/elasticsearch.*
    rm -rf ~/certs/ ~/certs.zip
}
function start_elasticsearch() {
    systemctl start elasticsearch
}
function gerate_user_elasticsearch() {
    /usr/share/elasticsearch/bin/elasticsearch-setup-passwords auto > $dic_temp"senhas.txt"
    senha_elastic=$(grep 'PASSWORD elastic' senhas.txt | awk '{print $NF}')
}
if [ "$(id -nu)" != "root" ];then
    echo ""
    echo "###########################################################################"
    echo "            Voce deve ter poder de root par executar este scrip.           "
    echo "###########################################################################"
    exit 0
else
    if [ ! -d $dic_temp ]; then
        mkdir -m 755 -p $dic_temp
    else
        rm -rf /tmp/MHSOC/*
    fi
    if [[ $P_01 = "-help" || $P_01 = "" ]]; then
        echo "É necessario definir argumento para instalação do Kaspersky
        Argumentos                   Ação
        -a       | Instalação automatizada
        -n       | Instalacão de Modulos
        -s       | Sobre o Script
        * Recomendado para instalação\nExemplo: script.sh [argumento]"
        exit 0
    elif [ $P_01 = "-a" ]; then
        install_dependencies()
        install_elasticsearch()
        config_elasticsearch()
        config_cert()
        start_elasticsearch()
        gerate_user_elasticsearch()
    fi
fi
    
