#!/bin/bash
#
# Script d'instalation des dependances pour le projet Easy-Elua
#
# Authors : Salem Harrache
#           Elizabeth Paz
# LGPL
#
# Syntaxe: # su - -c "./debian_install.sh"
# Syntaxe: or # sudo ./debian_install.sh
#

#################################
# Version de Sourcery a installer

SOURCERY_VERSION="2011.03-42"
SOURCERY_DIRNAME="arm-2011.03"
SOURCERY_TARGET="$(pwd)/CodeSourcery"

##############################

# Variables globales
#-------------------

APT_GET="sudo apt-get -q -y --force-yes"
WGET="wget --no-check-certificate"
DATE=`date +"%Y%m%d%H%M%S"`
LOG_FILE="/tmp/easy-elua-autoinstall-$DATE.log"

# Functions
#-----------------------------------------------------------------------------

displaymessage() {
  echo "$*"
}

displaytitle() {
  displaymessage "-------------------------------------------------------------------------------"
  displaymessage "$*"
  displaymessage "-------------------------------------------------------------------------------"
}

displayerror() {
  displaymessage "$*" >&2
}

# First parameter: ERROR CODE
# Second parameter: MESSAGE
displayerrorandexit() {
  local exitcode=$1
  shift
  displayerror "$*"
  exit $exitcode
}

# First parameter: MESSAGE
# Others parameters: COMMAND (! not |)
displayandexec() {
  local message=$1
  echo -n "[En cours] $message"
  shift
  echo ">>> $*" >> $LOG_FILE 2>&1
  sh -c "$*" >> $LOG_FILE 2>&1
  local ret=$?
  if [ $ret -ne 0 ]; then
    echo -e "\r\e[0;31m   [ERROR]\e[0m $message"
  else
    echo -e "\r\e[0;32m      [OK]\e[0m $message"
  fi
  return $ret
}

# Debut de l'installation
#-----------------------------------------------------------------------------

displaytitle "Install prerequisites"

# MaJ des depots
displayandexec "Update the repositories list" $APT_GET update

# Pre-requis
displayandexec "Install development tools" "$APT_GET install build-essential python scons"

displaytitle "Install Sourcery ARM toolchain version $SOURCERY_VERSION"

# Telechargement des fichiers
displayandexec "Donwload Sourcery G++ Lite $SOURCERY_VERSION for ARM EABI" $WGET https://sourcery.mentor.com/sgpp/lite/arm/portal/package8734/public/arm-none-eabi/arm-$SOURCERY_VERSION-arm-none-eabi-i686-pc-linux-gnu.tar.bz2

# Extract
displayandexec "Unpack Sourcery G++ Lite $SOURCERY_VERSION for ARM EABI" "tar -jxvf arm-$SOURCERY_VERSION-arm-none-eabi-i686-pc-linux-gnu.tar.bz2; rm $SOURCERY_TARGET -fr 2> /dev/null 1>&2; mv $SOURCERY_DIRNAME $SOURCERY_TARGET;"

displayandexec "Create activate script for Sourcery G++" "echo \"export PATH=$SOURCERY_TARGET/bin:\$PATH\" > ./activate_sourcery.sh"

displayandexec "Clean" rm arm-$SOURCERY_VERSION-arm-none-eabi-i686-pc-linux-gnu.tar.bz2


# Summary
echo ""
echo "-------------------------------------------------------------------------------"
echo "Instalation términé"
echo "Sourcery toolchain folder:        $SOURCERY_TARGET/$SOURCERY_DIRNAME"
echo "Script d'activation de sourcery:  $(pwd)/activate_sourcery.sh"
echo "-------------------------------------------------------------------------------"
echo ""

# Fin du script

