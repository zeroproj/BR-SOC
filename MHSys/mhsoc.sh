#!/bin/bash
##Erro 1 sEM rOOT
##Erro 100 Falha isntalaçao Elastic
clear
if [ "$(id -u)" != "0" ]; then
    whiptail --title "Autentificação requerida" --msgbox "Este script requer privilégios de administrador. Execute-o como root." 12 50
    exit 1
fi
dic_temp=/opt/MHSOC/
choice=$(whiptail --title "MHSOC" --menu "O que você deseja fazer?" 12 50 4 \
    "1" "Instalação automatizada" \
    "2" "Instalacão de Modulos" \
    "0" "Cancelar a instalação" 3>&1 1>&2 2>&3)
case $choice in
    1)
        bash $dic_temp'MHSys/dep.sh' "-a"
        $dic_temp'MHSys/elastic.sh'
        $dic_temp'MHSys/wserver.sh'
        $dic_temp'MHSys/filebeat.sh'
        $dic_temp'MHSys/kibana.sh'
        if [ $? -eq 0 ]; then
            echo "O script Elastic foi concluído com sucesso."
        else
            whiptail --title "Instalação Falhou" --msgbox "A instalação não foi concluída. Código de saída: $?" 12 50
            exit 0
        fi
        ;;
    0)
        whiptail --title "Instalação Cancelada" --msgbox "A instalação foi cancelada." 12 50
        exit 0
        ;;
    *)
        whiptail --title "Escolha Inválida" --msgbox "Escolha inválida. A instalação foi cancelada." 12 50
        exit 1
        ;;
esac
#if [ $? -eq 0 ]; then
#    echo "O script dep.sh foi concluído com sucesso."
#else
#    echo "O script dep.sh falhou. Código de saída: $?"
#fi