#!/bin/bash
#
# Script pour flasher un programme easy-elua
#
# Authors : Salem Harrache
#           Elizabeth Paz
# LGPL
#
# Syntaxe: # su - -c "./flash.sh myprogram.lua"
# Syntaxe: or # sudo ./flash.sh myprogram.lua
#

#################################
# Env

STFLASH="$(pwd)/env/utils/st-flash"

COMMAND="sudo $STFLASH write elua_lua_stm32f407vg.bin 0x08000000"

source activate_sourcery.sh
cd elua
rm ./romfs/autorun.lua
wget https://raw.github.com/SalemHarrache/elua-examples/master/led/led.lua -O  ./romfs/autorun.lua
scons board=STM32F4DSCY prog
echo $COMMAND
$COMMAND
