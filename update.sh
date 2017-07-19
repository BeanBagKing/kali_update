#!/bin/bash

echo "-------------------------------"
echo " Current Version Info Follows: "
echo "-------------------------------"
lsb_release -i
lsb_release -r
lsb_release -d
lsb_release -c
printf "Kernal Version: ";uname -r
printf "Processor Type: ";uname -m
echo "------------------------------"
echo "     Performing updates:      "
echo "------------------------------"
echo "----- CLEAN -----"
apt clean
echo "----- UPDATE -----"
apt update
echo "----- UPGRADE -----"
apt upgrade -y
echo "----- DIST-UPGRADE -----"
apt full-upgrade -y
# I've had this break text rendering. This was fixed with 'apt-get install --reinstall fonts-cantarell'
echo "----- AUTOREMOVE -----"
apt autoremove -y
echo "------------------------------"
echo " Device Version Info Follows: "
echo "------------------------------"
lsb_release -i
lsb_release -r
lsb_release -d
lsb_release -c
printf "Kernal Version: ";uname -r
printf "Processor Type: ";uname -m
echo "------------------------------"
echo "     Other Applications:      "
echo "------------------------------"
#echo "----- SNAP UPDATE -----"
## Uncomment this if you use snap
#snap refresh
echo "----- PIP -----"
pip install --upgrade pip
echo "----- WPSCAN -----"
wpscan --update
echo "----- NIKTO -----"
cd /usr/share/golismero/tools/nikto
perl nikto.pl -update
cd --
#echo "----- FRESHCLAM -----"
## Uncomment this if you use ClamAV
#freshclam
#echo "----- NESSUS -----"
## Uncomment if you use Nessus
## Don't be running scans... Stop the service, wait a few to make sure, upgrade, and start the service.
#service nessusd stop
#sleep 3
#/opt/nessus/sbin/nessuscli update --all
#sleep 3
#service nessusd start
echo "----- GITHUB -----"
# The following -should- grab updates from any github projects added by new_setup.sh. If you add more or remove these, fix them.
# Also, watch testssl since it doesn't use master and will likely change.
cd /root/Scripts/Abeebus
git pull origin master
cd --
cd /root/Scripts/Sublist3r
git pull origin master
cd --
cd /root/Scripts/kali_update
git pull origin master
cd --
cd /root/Scripts/EyeWitness
git pull origin master
cd --
cd /root/Scripts/testssl
git pull origin 2.9dev
cd --
cd /root/Scripts/Empire
git pull origin master
cd --
cd /root/Scripts/Windows-Exploit-Suggester
git pull origin master
cd --
cd /root/Scripts/mimipenguin
git pull origin master
cd --
cd /root/Scripts/kali-tools
git pull origin master
cd --
cd /root/Scripts/WPSeku
git pull origin master
cd --
cd /root/Scripts/unix-privesc-check2
git pull origin master
cd --
cd /root/Scripts/Linux_Exploit_Suggester
git pull origin master
cd --
cd /root/Scripts/LinEnum
git pull origin master
cd --
cd /root/Scripts/PRET
git pull origin master
cd --
echo "----- FIN -----"
