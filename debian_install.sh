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
# Env

SOURCERY_VERSION="2011.03-42"
SOURCERY_DIRNAME="arm-2011.03"
mkdir "$(pwd)/env/"
SOURCERY_TARGET="$(pwd)/env/CodeSourcery"
STFLASH_TARGET="$(pwd)/env/utils"

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

# update system deposit
#displayandexec "Update the repositories list" $APT_GET update

# prerequisite
#displayandexec "Install development tools" "$APT_GET install build-essential python scons"

#displaytitle "Install Sourcery ARM toolchain version $SOURCERY_VERSION"

# toochain
#displayandexec "Donwload Sourcery G++ Lite $SOURCERY_VERSION for ARM EABI" $WGET https://sourcery.mentor.com/sgpp/lite/arm/portal/package8734/public/arm-none-eabi/arm-$SOURCERY_VERSION-arm-none-eabi-i686-pc-linux-gnu.tar.bz2

# Extraction
#displayandexec "Unpack Sourcery G++ Lite $SOURCERY_VERSION for ARM EABI" "tar -jxvf arm-$SOURCERY_VERSION-arm-none-eabi-i686-pc-linux-gnu.tar.bz2; rm $SOURCERY_TARGET -fr 2> /dev/null 1>&2; mv $SOURCERY_DIRNAME $SOURCERY_TARGET;"

# script which enables toochain on demand
#displayandexec "Create activate script for Sourcery G++" "echo \"export PATH=$SOURCERY_TARGET/bin:\$PATH\" > $(pwd)/activate_sourcery.sh"

# Donwload stlink
displayandexec "Git clone stlink" "git clone git@github.com:SalemHarrache/stlink.git"

# Make stlink
source "$(pwd)/activate_sourcery.sh"
cd stlink
displayandexec "Compiling st-flash" "make; mv flash/st-flash ../;"
cd ../

displayandexec "Git clone elua" git clone git@github.com:SalemHarrache/elua.git

cd elua
displayandexec "Compiling elua for STM32F4DSCY" "scons board=STM32F4DSCY prog"
cd ../

displayandexec "Clean" rm arm-$SOURCERY_VERSION-arm-none-eabi-i686-pc-linux-gnu.tar.bz2 stlink -fr



# Summary
echo ""
echo "Installation succeed !"

echo "-------------------------------------------------------------------------------"
echo "Sourcery toolchain folder:        $SOURCERY_TARGET/$SOURCERY_DIRNAME"
echo "stlink flash utils floder:        $(pwd)/stlink/flask"
echo "Elua floder:                      $(pwd)/elua"
echo "Activate sourcery toolchain:      $(pwd)/activate_sourcery.sh"
echo "-------------------------------------------------------------------------------"
echo ""
