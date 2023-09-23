#!/bin/bash
clear
echo "###########################################################################"
echo "################# INSTALAÇÃO PROTEÇÃO KASPERSKY ENDPOINT ##################"
echo "##############           OS: Ubuntu LTS                     ###############"
echo -e "############################################################### MHHSOC ####\n"
#Desenvolvido por Lucas Matheus e Gabriel
#################################################
if [ "$(id -u)" != "0" ];then
    echo ""
    echo "###########################################################################"
    echo "            Voce deve ter poder de root par executar este scrip.           "
    echo "###########################################################################"
    exit 0
else






    #MHSOC Install
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