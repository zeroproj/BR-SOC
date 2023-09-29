#!/bin/bash
clear
echo "###########################################################################"
echo "#################                   MHSOC                ##################"
echo "##############           OS: Ubuntu LTS                     ###############"
echo -e "############################################################### MHHSOC ####\n"
#################################################
P_01="$1" #Parametro 1 - Não Alterar
dic_temp=/opt/MHSOC/
EFolder=$(dirname $0)
senha_elastic=""
#Desenvolvido por Lucas Matheus e Gabriel
#################################################
if [ "$(id -nu)" != "root" ];then
    echo ""
    echo "###########################################################################"
    echo "            Voce deve ter poder de root par executar este scrip.           "
    echo "###########################################################################"
    exit 0
else
    if [[ $P_01 = "-help" || $P_01 = "" ]]; then
        echo "É necessario definir argumento para instalação do Kaspersky
        Argumentos                   Ação
        -a       | Instalação automatizada
        -n       | Instalacão de Modulos
        -s       | Sobre o Script
        * Recomendado para instalação\nExemplo: script.sh [argumento]"
        exit 0
    elif [ $P_01 = "-a" ]; then
        MHSys/dep.sh
        if [ $? -eq 0 ]; then
            echo "O script dep.sh foi concluído com sucesso."
        else
            echo "O script dep.sh falhou. Código de saída: $?"
        fi
        MHSys/elastic.sh
        if [ $? -eq 0 ]; then
            echo "O script dep.sh foi concluído com sucesso."
        else
            echo "O script dep.sh falhou. Código de saída: $?"
        fi
    fi
fi