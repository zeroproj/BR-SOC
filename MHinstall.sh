#!/bin/bash
clear
echo "###########################################################################"
echo "#################                   MHSOC                ##################"
echo "##############           OS: Ubuntu LTS                     ###############"
echo -e "############################################################### MHHSOC ####\n"
dic_temp=/opt/MHSOC/
if [ "$(id -nu)" != "root" ];then
    echo ""
    echo "###########################################################################"
    echo "            Voce deve ter poder de root par executar este scrip.           "
    echo "###########################################################################"
    exit 0
else
    if [ ! -d $dic_temp ]; then
        mkdir -m 755 -p $dic_temp
        mv * $dic_temp
    else
        echo "BETA"
        rm -rf $dic_temp'*'
        mv * $dic_temp
    fi
    ln -s $dic_temp/MHSys/mhsoc.sh /usr/local/bin/MHSoc
    chmod +x /usr/local/bin/MHSoc
    chmod +x $dic_temp'/MHSys/*.sh'
fi
    
