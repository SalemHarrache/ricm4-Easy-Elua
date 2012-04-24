#!/bin/bash
#
# Run eLua shell
#
# Authors : Salem Harrache
#           Elizabeth Paz
#
# Syntaxe: # ./run_shell.sh"
#
#################################

screen -D -R -S elua_shell /dev/ttyUSB0 115200 8n1

