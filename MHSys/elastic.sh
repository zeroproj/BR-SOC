#!/bin/bash
install_dir="/opt/MHSOC/"
senha_elastic=""
#########################################################
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
    unlink /etc/elasticsearch/elasticsearch.yml
    #cp $install_dir'MHConf/elasticsearch.yml' /etc/elasticsearch/elasticsearch.yml
    ln -s $install_dir'MHConf/elasticsearch.yml' /etc/elasticsearch/elasticsearch.yml
    #curl -so /etc/elasticsearch/elasticsearch.yml https://raw.githubusercontent.com/zeroproj/MHSoc/main/MHConf/elasticsearch.yml?token=GHSAT0AAAAAACH7RYRWE6J3G6CZVE5MUOMOZIPN55A
}
function config_cert() {
    echo -e "- Baixando arquivo de configuração Certificado"
    unlink /usr/share/elasticsearch/instances.yml
    #cp $install_dir'MHConf/instances.yml' /usr/share/elasticsearch/instances.yml
    ln -s $install_dir'MHConf/instances.yml' /usr/share/elasticsearch/instances.yml
    #curl -so /usr/share/elasticsearch/instances.yml https://raw.githubusercontent.com/zeroproj/MHSoc/main/MHConf/instances.yml?token=GHSAT0AAAAAACH7RYRWBKO2VO55LBIW7GAGZIPO23Q
    /usr/share/elasticsearch/bin/elasticsearch-certutil cert ca --pem --in /usr/share/elasticsearch/instances.yml --keep-ca-key --out ~/certs.zip
    unzip ~/certs.zip -d ~/certs
    mkdir /etc/elasticsearch/certs/ca -p
    cp -R ~/certs/ca/ ~/certs/MHelastic/* /etc/elasticsearch/certs/
    chown -R elasticsearch: /etc/elasticsearch/certs
    chmod -R 500 /etc/elasticsearch/certs
    chmod 400 /etc/elasticsearch/certs/ca/ca.* /etc/elasticsearch/certs/MHelastic.*
    rm -rf ~/certs/ ~/certs.zip
}
function start_elasticsearch() {
    systemctl start elasticsearch
}
function gerate_user_elasticsearch() {
    passwords=$(echo -e "Y\n" | /usr/share/elasticsearch/bin/elasticsearch-setup-passwords auto)
    if [ $? -eq 0 ]; then
        echo "$passwords" > $install_dir'MHSocSenha.txt'
        senha_elastic=$(grep 'PASSWORD elastic' $install_dir'MHSocSenha.txt' | awk '{print $NF}')
        cat $install_dir'MHSocSenha.txt'
        echo "Por favor, salve as senhas geradas acima em um local seguro."
        read -p "Pressione Enter para continuar..."
    else
        echo "Erro ao gerar senhas"
        exit 1
    fi
}
function test_system_all(){
    response=$(curl -XGET https://localhost:9200 -u elastic:"$senha_elastic" -k)
    if [[ $response == *"\"name\" : \"MHelastic\""* ]]; then
    else
        exit 100
    fi
} 
if [ "$(id -u)" != "0" ]; then
    echo "Este script deve ser executado como root."
    exit 1
fi
install_elasticsearch
config_elasticsearch
config_cert
start_elasticsearch
gerate_user_elasticsearch
test_system_all