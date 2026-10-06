#!/bin/bash

# 24 Oct 2018 - Kali 2018.3
# 20 Jan 2025 - very minor change for lsb_release 
# 25 Jan 2025 - I still use this script all the time, but my focus has shifted to forensics and I don't use most of the pentesting stuff
#               Therefore, I've cut almost all of that out, leaving all of the apt stuff, snap, and changing pip to pipx.
#               Other minor changes include checks for root, ntpdate, and snap
# 06 Oct 2026 - Cleanup of deprecated ntpdate, user specific updateing of pipx, addition of flatpack, other minor tweaks and spelling fixes.

# sudo wget https://raw.githubusercontent.com/BeanBagKing/kali_update/refs/heads/master/update.sh -O /usr/bin/update.sh

RED='\033[1;31m'
GRN='\033[1;32m'
YEL='\033[1;33m'
# shellcheck disable=SC2034  # kept as a spare color for future use
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
# ntpdate is deprecated on modern Debian-based systems; use systemd-timesyncd (default
# on Debian/Kali/Ubuntu/Pop!_OS) and fall back to chrony if that's what's installed.
echo -e "${YEL}----- UPDATING TIME -----${NC}"
if command -v timedatectl >/dev/null 2>&1; then
  # Enable NTP, then restart timesyncd to force an immediate resync (handy after a VM resume)
  timedatectl set-ntp true
  systemctl restart systemd-timesyncd 2>/dev/null || true
elif command -v chronyc >/dev/null 2>&1; then
  chronyc -a makestep
else
  echo -e "${RED}no time sync tool (timedatectl/chrony) found, skipping${NC}"
fi
echo -e "${YEL}-------------------------------${NC}"
echo -e "${YEL} Current Version Info Follows: "
echo -e "${YEL}-------------------------------${NC}"
lsb_release -i 2>/dev/null
lsb_release -r 2>/dev/null
lsb_release -d 2>/dev/null
lsb_release -c 2>/dev/null
printf "Kernel Version: ";uname -r
printf "Processor Type: ";uname -m
echo -e "${YEL}------------------------------${NC}"
echo -e "${YEL}     Performing updates:      ${NC}"
echo -e "${YEL}------------------------------${NC}"
echo -e "${YEL}----- CLEAN -----${NC}"
apt clean
echo -e "${YEL}----- UPDATE -----${NC}"
apt update
echo -e "${YEL}----- FULL-UPGRADE -----${NC}"
# full-upgrade is a superset of upgrade (it also removes packages when needed to
# complete the upgrade), so running plain 'apt upgrade' first is redundant.
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
printf "Kernel Version: ";uname -r
printf "Processor Type: ";uname -m
echo -e "${YEL}------------------------------${NC}"
echo -e "${YEL}     Other Applications:      "
echo -e "${YEL}------------------------------${NC}"
echo -e "${YEL}----- SNAP UPDATE -----${NC}"
if ! command -v snap >/dev/null 2>&1
then
  echo -e "${RED}snap not found, skipping${NC}"
else
  snap refresh
fi
echo -e "${YEL}----- FLATPAK UPDATE -----${NC}"
if ! command -v flatpak >/dev/null 2>&1
then
  echo -e "${RED}flatpak not found, skipping${NC}"
else
  flatpak update -y
  # Remove unused runtimes/extensions left behind by updates
  flatpak uninstall --unused -y
fi
echo -e "${YEL}----- PIPX -----${NC}"
# pipx installs live in a user's ~/.local, not root's. Upgrade for the user who invoked
# sudo (SUDO_USER); fall back to root if the script was run as a direct root login.
PIPX_USER="${SUDO_USER:-root}"
if [ "$PIPX_USER" = "root" ]; then
  if ! command -v pipx >/dev/null 2>&1; then
    echo -e "${RED}pipx not found, skipping${NC}"
  else
    pipx upgrade-all
  fi
else
  # Run through the user's login shell so ~/.local/bin is on PATH
  if ! sudo -u "$PIPX_USER" bash -lc 'command -v pipx >/dev/null 2>&1'; then
    echo -e "${RED}pipx not found for ${PIPX_USER}, skipping${NC}"
  else
    echo -e "${YEL}(upgrading pipx packages for ${PIPX_USER})${NC}"
    sudo -u "$PIPX_USER" bash -lc 'pipx upgrade-all'
  fi
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
