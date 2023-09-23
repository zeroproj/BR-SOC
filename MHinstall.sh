#!/bin/bash
clear
echo "###########################################################################"
echo "################# INSTALAÇÃO PROTEÇÃO KASPERSKY ENDPOINT ##################"
echo "##############           OS: Ubuntu LTS                     ###############"
echo -e "############################################################### MHHSOC ####\n"
P_01="$1" #Parametro 1 - Não Alterar 
dic_temp=/tmp/MHSOC/
EFolder=$(dirname $0)
#Desenvolvido por Lucas Matheus e Gabriel
#################################################
function install_dependencies() {
    apt-get install apt-transport-https zip unzip lsb-release curl gnupg
}
function install_elasticsearch() {
    apt-get install apt-transport-https zip unzip lsb-release curl gnupg
    echo -e "- Instalando Pacotes Necessarios"
    apt-get install apt-transport-https zip unzip lsb-release curl gnupg
    #Elasticsearch Install
    echo -e "- Configurando Repositorio"
    curl -s https://artifacts.elastic.co/GPG-KEY-elasticsearch | gpg --no-default-keyring --keyring gnupg-ring:/usr/share/keyrings/elasticsearch.gpg --import && chmod 644 /usr/share/keyrings/elasticsearch.gpg
    echo "deb [signed-by=/usr/share/keyrings/elasticsearch.gpg] https://artifacts.elastic.co/packages/7.x/apt stable main" | tee /etc/apt/sources.list.d/elastic-7.x.list
    apt-get update
    echo -e "- Instalando Pacotes Elasticsearch"
    apt-get install elasticsearch=7.17.12
    echo -e "- Baixando arquivo de configuração"
    curl -so /etc/elasticsearch/elasticsearch.yml https://packages.wazuh.com/4.5/tpl/elastic-basic/elasticsearch_all_in_one.yml
}
if [ "$(id -u)" != "0" ];then
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
    echo "É necessario definir argumento para instalação do Kaspersky
    Argumentos                   Ação
       -a       | Instalação automatizada
       -r       | Remover Kaspersky for Linux
       -c       | Configurar Kaspersky for Linux - On-premise
       -u       | Verificar Atualização
       -s       | Sobre o Script
    * Recomendado para instalação\nExemplo: script.sh [argumento]"
    exit 0
fi
    
