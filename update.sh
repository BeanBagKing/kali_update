#!/bin/bash

# 24 Oct 2018 - Kali 2018.3
#   20 Jan 2025 - very minor change for lsb_release 
# 25 Jan 2025 - I still use this script all the time, but my focus has shifted to forensics and I don't use most of the pentesting stuff
#               Therefore, I've cut almost all of that out, leaving all of the apt stuff, snap, and changing pip to pipx.
#               Other minor changes include checks for root, ntpdate, and snap

# sudo wget https://raw.githubusercontent.com/BeanBagKing/kali_update/refs/heads/master/update.sh -O /usr/bin/update.sh

RED='\033[1;31m'
GRN='\033[1;32m'
YEL='\033[1;33m'
BLU='\033[1;34m'
NC='\033[0m' # No Color

# Check if the script is run as root or with sudo
if [[ $EUID -ne 0 ]]; then
  echo -e "${YEL}---------------------------------------${NC}"
  echo -e "${YEL}script must be run as root or with sudo${NC}"
  echo -e "${YEL}---------------------------------------${NC}"
  exit 1
fi

# Time on VM's can be incorrect after I resume. If you don't need this, comment it out
echo -e "${YEL}----- UPDATING TIME -----${NC}"
if ! command -v ntpdate 2>&1 >/dev/null
then
  echo -e "${RED}ntpdate not found, skipping${NC}"
else
  ntpdate time.nist.gov
fi
echo -e "${YEL}-------------------------------${NC}"
echo -e "${YEL} Current Version Info Follows: "
echo -e "${YEL}-------------------------------${NC}"
lsb_release -i 2>/dev/null
lsb_release -r 2>/dev/null
lsb_release -d 2>/dev/null
lsb_release -c 2>/dev/null
printf "Kernal Version: ";uname -r
printf "Processor Type: ";uname -m
echo -e "${YEL}------------------------------${NC}"
echo -e "${YEL}     Performing updates:      ${NC}"
echo -e "${YEL}------------------------------${NC}"
echo -e "${YEL}----- CLEAN -----${NC}"
apt clean
echo -e "${YEL}----- UPDATE -----${NC}"
apt update
echo -e "${YEL}----- UPGRADE -----${NC}"
apt upgrade -y
echo -e "${YEL}----- DIST-UPGRADE -----${NC}"
apt full-upgrade -y
# I've had this break text rendering. This was fixed with 'apt-get install --reinstall fonts-cantarell'
echo -e "${YEL}----- AUTOREMOVE -----${NC}"
apt autoremove -y
echo -e "${YEL}------------------------------${NC}"
echo -e "${YEL} Device Version Info Follows: "
echo -e "${YEL}------------------------------${NC}"
lsb_release -i 2>/dev/null
lsb_release -r 2>/dev/null
lsb_release -d 2>/dev/null
lsb_release -c 2>/dev/null
printf "Kernal Version: ";uname -r
printf "Processor Type: ";uname -m
echo -e "${YEL}------------------------------${NC}"
echo -e "${YEL}     Other Applications:      "
echo -e "${YEL}------------------------------${NC}"
echo -e "${YEL}----- SNAP UPDATE -----${NC}"
if ! command -v snap 2>&1 >/dev/null
then
  echo -e "${RED}snap not found, skipping${NC}"
else
  snap refresh
fi
echo -e "${YEL}----- PIPX -----${NC}"
if ! command -v pipx 2>&1 >/dev/null
then
  echo -e "${RED}pipx not found, skipping${NC}"
else
  pipx upgrade-all
fi
# echo -e "${YEL}----- GITHUB -----${NC}"
# Leaving this in here for future reference. Also, watch testssl.sh since it doesn't use master and will likely change.
# cd /root/Scripts/Abeebus
# git pull origin master
# cd --
echo -e "${YEL}----- REBOOT? -----${NC}"
if [ -f /var/run/reboot-required ]; then
  echo -e "${RED}Reboot Required${NC}"
else
  echo -e "${GRN}Nothing Here${NC}"
fi
echo -e "${YEL}----- FIN -----${NC}"
