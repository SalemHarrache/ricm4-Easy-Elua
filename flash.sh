#!/bin/bash
#
# Script pour flasher un programme easy-elua
#
# Authors : Salem Harrache
#           Elizabeth Paz
# LGPL
#
# Syntaxe: # ./flash.sh myprogram.lua"
#
#################################
# Env

STFLASH="$(pwd)/env/utils/st-flash"
COMMAND="sudo $STFLASH write elua_lua_stm32f407vg.bin 0x08000000"

source activate_sourcery.sh

if [ $# -ne 1 ]
then
    echo Usage: $0 myprogram.lua  
    exit 1
fi

file=$1

if test ! -f $file; then
    echo Erreur: $file "n'est pas un fichier"
    exit 1
fi

if test ! -d "elua"; then
    echo Erreur: Vous devez installer elua
    exit 1
fi

#rm /elua/romfs/autorun.lua
cp $file ./elua/romfs/autorun.lua
cd elua
scons board=STM32F4DSCY prog
echo $COMMAND
$COMMAND
