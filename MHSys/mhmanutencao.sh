clear
if [ "$(id -u)" != "0" ]; then
    whiptail --title "Autentificação requerida" --msgbox "Este script requer privilégios de administrador. Execute-o como root." 12 50
    exit 1
fi
dic_temp=/opt/MHSOC/
choice=$(whiptail --title "MHSOC" --menu "BRSOC - ASSITENTE DE CONFIGURACAO" 12 50 4 \
    "1" "Atualizar BRSOC e OS" \
    "2" "Reparar BRSOC" \
    "3" "Remover BRSOC" \
    "0" "Voltar" 3>&1 1>&2 2>&3)
case $choice in
    1)  
        echo ""
        ;;
    2)
        echo ""
        ;;
    3)
        echo ""
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