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


## Début
if [ $# -ne 1 ]; then
    echo Erreur: vous devez spécifier le chemin
else
    file=$1
    if test ! -f $file; then
        echo Erreur: $file "n'est pas un fichier"
        exit 1
    fi
    screen -S elua_shell -X eval "stuff 'recv'^m"
    sleep 1
    screen -S elua_shell -X eval "exec !! sx -Xb $file"
fi

