# ERRO 300
#!/bin/bash
install_dir="/opt/MHSOC/"
domain_name=""
function install_nginx() {
    echo -e "- Instalando Pacotes Nginx e Snapd"
    apt remove certbot -y
    apt remove --purge nginx* -y
    apt install nginx snapd -y
    if [ $? -eq 0 ]; then
        echo "- Nginx: Instalado com sucesso"
        snap install core; snap refresh core
    else
        echo "- Nginx: Erro ao instalar o Certbot"
        exit 500
    fi
    snap install --classic certbot
    if [ $? -eq 0 ]; then
        echo "- Certbot: Instalado com sucesso"
    else
        echo "- Certbot: Erro ao instalar o Certbot"
        exit 500
    fi
}

function conf_nginx() {
    unlink /etc/nginx/sites-enabled/default
    read -p "Digite o nome de domínio para o servidor: " domain_name
    if [ -z "$domain_name" ]; then
        echo "O nome de domínio não pode estar em branco."
        exit 500
    fi
    # Conteúdo do arquivo de configuração Nginx
    config_content="server {
        listen 80 default_server;
        server_name $domain_name;

        location / {
            proxy_pass https://127.0.0.1:4433;
            proxy_set_header Host \$host;
        }
    }
    "
    arquivo_config="/etc/nginx/conf.d/wazuh.conf"
    echo "$config_content" | sudo tee "$arquivo_config" > /dev/null
    if [ $? -eq 0 ]; then
        echo "Arquivo de configuração Nginx criado em $arquivo_config"
    else
        echo "Erro ao criar o arquivo de configuração Nginx."
        exit 500
    fi
}

function config_cert() {
    certbot --nginx -d $domain_name
    if [ $? -eq 0 ]; then
        echo "Certificado criado para o dominio $domain_name"
        sed -i "s/server.port: 443/server.port: 4433/g" $install_dir'MHConf/kibana.yml'
        sed -i "s/server.host: 0.0.0.0/server.host: 127.0.0.1/g" $install_dir'MHConf/kibana.yml'
        systemctl restart kibana
    else
        echo "Erro ao criar o arquivo de configuração Nginx."
        exit 500
    fi
}
function start_nginx() {
    systemctl restart nginx
    if [ $? -eq 0 ]; then
        echo "- Nginx: Configurado com Sucesso."
    else
        echo "- Nginx: Falha "
        exit 500
    fi
}

if [ "$(id -u)" != "0" ]; then
    echo "Este script deve ser executado como root."
    exit 1
else
    install_nginx
    conf_nginx
    start_nginx
    config_cert
    start_nginx
fi