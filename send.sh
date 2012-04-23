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


SESSION_NAME="elua_shell_$(date +"%Y%m%d%H%M%S")"


if [ $# -ne 1 ]; then
    echo Erreur: vous devez spécifier le chemin
else
    file=$1
    if test ! -f $file; then
        echo Erreur: $file "n'est pas un fichier"
        exit 1
    fi
    screen -dmS $SESSION_NAME /dev/ttyUSB0 115200 8n1
    sh -c "sleep 1;screen -S $SESSION_NAME -X eval \"stuff ''^m\"" &
    sh -c "sleep 2;screen -S $SESSION_NAME -X eval \"stuff 'recv'^m\"" &
    sh -c "sleep 3;screen -S $SESSION_NAME -X eval \"exec !! sx -Xb $file\"" &
    screen -D -R -S $SESSION_NAME
fi

