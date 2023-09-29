#!/bin/bash
show_intro() {
    whiptail --title "Bem-vindo à Instalação do MHSOC" \
    --msgbox "Esta é a instalação do MHSOC. Clique em OK para continuar." 12 50
}
ask_for_confirmation() {
    whiptail --title "Confirmação" \
    --yesno "Você deseja continuar com a instalação?" 12 50
    if [ $? -eq 0 ]; then
        return 0
    else
        return 1
    fi
}
clear
show_intro
if [ "$(id -u)" != "0" ]; then
    whiptail --title "Autentificação requerida" --msgbox "Este script requer privilégios de administrador. Execute-o como root." 12 50
    exit 1
fi
ask_for_confirmation || exit 0
install_dir="/opt/MHSOC/"
if [ ! -d "$install_dir" ]; then
    mkdir -m 755 -p "$install_dir"
    mv * "$install_dir"
    ln -s $install_dir'MHSys/mhsoc.sh' /usr/local/bin/MHSoc
    chmod +x /usr/local/bin/MHSoc
    chmod +x $install_dir'/MHSys/*.sh'
    whiptail --title "Instalação Concluída" --msgbox "A instalação foi concluída com sucesso." 12 50
else
    choice=$(whiptail --title "Versão Anterior Detectada" --menu "O que você deseja fazer?" 12 50 4 \
        "1" "Substituir a versão anterior" \
        "2" "Cancelar a instalação" 3>&1 1>&2 2>&3)
    case $choice in
        1)
            rm -rf "$install_dir"*
            mv * "$install_dir"
            rm /usr/local/bin/MHSoc
            ln -s $install_dir'MHSys/mhsoc.sh' /usr/local/bin/MHSoc
            chmod +x /usr/local/bin/MHSoc
            chmod +x $install_dir'/MHSys/*.sh'
            whiptail --title "Instalação Concluída" --msgbox "A instalação foi concluída com sucesso." 12 50
            ;;
        2)
            whiptail --title "Instalação Cancelada" --msgbox "A instalação foi cancelada." 12 50
            exit 0
            ;;
        *)
            whiptail --title "Escolha Inválida" --msgbox "Escolha inválida. A instalação foi cancelada." 12 50
            exit 1
            ;;
    esac
fi