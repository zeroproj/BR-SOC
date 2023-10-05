#!/bin/bash
remote_url="https://raw.githubusercontent.com/zeroproj/BR-SOC/main/MHSys/brsov_version?token=GHSAT0AAAAAACH7RYRXYV277YYX2LNF7PXMZI67WJQ"
github_repo="https://github.com/zeroproj/BR-SOC.git"
install_dir="/opt/MHSOC/"
local_file=$install_dir'MHSys/brsov_version'
destination_dir=$install_dir'MHUpdate/UP/'
source_dir_conf=$destination_dir'MHConf'
destination_dir_conf=$install_dir'MHConf'
if curl --output /dev/null --silent --head --fail "$remote_url"; then
    # Baixa o arquivo remoto
    remote_version=$(curl -s "$remote_url")
    if [ -e "$local_file" ]; then
        local_version=$(cat "$local_file")
        # Compara as versões
        if [ "$remote_version" -eq "$local_version" ]; then # As versões são iguais
            whiptail --title "Update BRSOC" --msgbox "Sistema atualizado." 12 50
        elif [ "$remote_version" -gt "$local_version" ]; then # A versão remota é maior
            whiptail --title "Update BRSOC" --msgbox "Sistema será atualizado." 12 5
            rm $destination_dir -rf
            mkdir -p "$destination_dir"
            git clone "$github_repo" "$destination_dir"

            for file in "$source_dir_conf"/*; do
                if [ -e "$destination_dir_conf/$(basename "$file")" ]; then
                    echo "O arquivo '$(basename "$file")' de configuraçao já esta atualizado no diretório de destino."
                else
                    mv "$file" "$destination_dir_conf"
                    echo "O arquivo '$(basename "$file")' de configuraçao foi atualizado no diretório de destino."
                fi
            done
            rm $install_dir'MHSys/' -rf
            mv $destination_dir'MHSys' $install_dir
            unlink /usr/local/bin/MHSoc
            ln -s $install_dir'MHSys/mhsoc.sh' /usr/local/bin/MHSoc
            chmod +x /usr/local/bin/MHSoc
            chmod +x "$install_dir/MHSys"/*.sh
            rm $destination_dir -rf
        else # A versão local é maior (não deve ocorrer)
            whiptail --title "Update BRSOC" --msgbox "Erro: A versão local é maior do que a versão remota." 12 50
        fi
    else # O arquivo local não existe, portanto, será atualizado
        whiptail --title "Update BRSOC" --msgbox "Sistema será atualizado." 12 50
    fi
else # O arquivo remoto não está disponível
    whiptail --title "Update BRSOC" --msgbox "Erro: Não foi possível acessar o arquivo remoto." 12 50
fi