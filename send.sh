#!/bin/bash
#
# Script pour envoyer un programme easy_elua par xmodem
#
# Authors : Salem Harrache
#           Elizabeth Paz
# LGPL
#
# Syntaxe: # ./send.sh [myprogram.lua]"
#
#################################


if [ $# -ne 1 ]; then
    echo Erreur: vous devez spécifier le chemin
else
    file=$1
    if test ! -f $file; then
        echo Erreur: $file "n'est pas un fichier"
        exit 1
    fi
    #screen -D -R -S elua_shell /dev/ttyUSB0 115200 8n1
    #sh -c 'screen -dmS elua_shell /dev/ttyUSB0 115200 8n1 &'
    #screen -D -R -S elua_shell /dev/ttyUSB0 115200 8n1
    screen -dmS elua_shell /dev/ttyUSB0 115200 8n1
    sleep 2
    screen -S elua_shell -X eval "stuff ''^m"
    screen -S elua_shell -X eval "stuff ''^m"
    sleep 1
    screen -S elua_shell -X eval "stuff 'recv'^m"
    sleep 1
    screen -S elua_shell -X eval "exec !! sx -Xb $file"
    screen -x elua_shell
fi

