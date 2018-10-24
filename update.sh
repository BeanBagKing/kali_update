#!/bin/bash

# Updated 24 Oct 2018
# for for Kali 2018.3

RED='\033[1;31m'
GRN='\033[1;32m'
YEL='\033[1;33m'
BLU='\033[1;34m'
NC='\033[0m' # No Color

#echo -e "${YEL}${YEL}--${NC}Upgrading and installing useful PIP stuff"

# Time on VM's can be incorrect after I resume. If you don't need this, comment it out
echo -e "${YEL}----- UPDATING TIME -----${NC}"
ntpdate time.nist.gov

echo -e "${YEL}-------------------------------${NC}"
echo -e "${YEL} Current Version Info Follows: "
echo -e "${YEL}-------------------------------${NC}"
lsb_release -i
lsb_release -r
lsb_release -d
lsb_release -c
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
lsb_release -i
lsb_release -r
lsb_release -d
lsb_release -c
printf "Kernal Version: ";uname -r
printf "Processor Type: ";uname -m
echo -e "${YEL}------------------------------${NC}"
echo -e "${YEL}     Other Applications:      "
echo -e "${YEL}------------------------------${NC}"
#echo -e "${YEL}----- SNAP UPDATE -----${NC}"
## Uncomment this if you use snap
#snap refresh
echo -e "${YEL}----- PIP -----${NC}"
pip install --upgrade pip
echo -e "${YEL}----- WPSCAN -----${NC}"
wpscan --update
echo -e "${YEL}----- NIKTO -----${NC}"
cd /usr/share/golismero/tools/nikto
perl nikto.pl -update
cd --
#echo -e "${YEL}----- FRESHCLAM -----${NC}"
## Uncomment this if you use ClamAV
#freshclam
#echo -e "${YEL}----- NESSUS -----${NC}"
## Uncomment if you use Nessus
## Don't be running scans... Stop the service, wait a few to make sure, upgrade, and start the service.
#service nessusd stop
#sleep 3
#/opt/nessus/sbin/nessuscli update --all
#sleep 3
#service nessusd start
echo -e "${YEL}----- GITHUB -----${NC}"
# The following -should- grab updates from any github projects added by new_setup.sh. If you add more or remove these, fix them.
# Also, watch testssl since it doesn't use master and will likely change.
cd /root/Scripts/Abeebus
git pull origin master
cd --
cd /root/Scripts/Rebeebus
git pull origin master
cd --
cd /root/Scripts/DidierStevensSuite
git pull origin master
cd --
cd /root/Scripts/kali-tools
git pull origin master
cd --
cd /root/Scripts/kali_update
git pull origin master
cd --
cd /root/Scripts/LinEnum
git pull origin master
cd --
cd /root/Scripts/Linux_Exploit_Suggester
git pull origin master
cd --
cd /root/Scripts/mimipenguin
git pull origin master
cd --
cd /root/Scripts/PRET
git pull origin master
cd --
cd /root/Scripts/unix-privesc-check2
git pull origin master
cd --
cd /root/Scripts/Windows-Exploit-Suggester
git pull origin master
cd --
echo -e "${YEL}----- REBOOT? -----${NC}"
if [ -f /var/run/reboot-required ]; then
  echo -e "${RED}Reboot Required${NC}"
else
  echo -e "${GRN}Nothing Here${NC}"
fi
echo -e "${YEL}----- FIN -----${NC}"
