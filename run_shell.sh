#!/bin/bash
#
# Script pour flasher un programme easy-elua
#
# Authors : Salem Harrache
#           Elizabeth Paz
# LGPL
#
# Syntaxe: # ./run_shell.sh"
#
#################################
# Env

screen -D -R -S elua_shell /dev/ttyUSB0 115200 8n1
