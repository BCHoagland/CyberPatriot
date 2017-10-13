#!/bin/bash

rootUser=hoggland

unwantedFileTypes=( mp3 mp4 mov avi wmv wma jpg jpeg )

red="\E[1;31m"
green="\E[1;32m"
yellow="\E[1;33m"
blue="\E[1;34m"
magenta="\E[1;35m"

echo -e "${magenta}====================PREP===================="
tput sgr0

#enable firewall
sudo ufw enable
echo -e "${blue}firewall enabled"
tput sgr0

#install antivirus
sudo apt-get install clamtk
echo -e "${blue}clamTK antivirus installed"
tput sgr0

#disable root login
sudo passwd -l root
echo -e "${blue}root user disabled"
tput sgr0

#install chrootkit
sudo apt-get install chkrootkit
echo -e "${blue}chrootkit installed"
tput sgr0

#install bum
sudo apt-get install bum
echo -e "${blue}bum installed"
tput sgr0

#set up audits
sudo apt-get install auditd
sudo auditctl -e 1
echo -e "${blue}auditing set up"
tput sgr0

#install cracklib
sudo apt-get install libpam-cracklib
echo -e "${blue}cracklib installed"
tput sgr0

#enable password security for single-user mode and disable ctrl-alt-delete combination
sudo nano /etc/inittab

#disable the Magic SysRq facility
sudo nano /etc/sysctl.conf

#check past sudo commands
sudo nano /var/log/auth.log

#set up permissions for sudo group
sudo nano /etc/sudoers

#set up auditing settings
sudo nano /etc/audit/auditd.conf

#configure password settings
sudo nano /etc/pam.d/common-password
sudo gedit /etc/login.defs

#configure authentication settings
sudo nano /etc/pam.d/common-auth

#check audit cache
echo -e "${yellow}====================\nAUDIT CACHE\n===================="
tput sgr0
sudo auditctl -e 1

echo -e "\n\n${magenta}====================PARSING FILES===================="
tput sgr0
for fileType in ${unwantedFileTypes[@]}; do
	echo -e "${yellow}====================\nCURRENT FILE TYPE: ${fileType}\n===================="
	tput sgr0
	#filesToRemove=()
	sudo find /home -type f -name "*.${fileType}"
	sudo find /home -type f -name "*.${fileType}" -delete
	#echo -e "${blue}All ${fileType} files removed"
	#tput sgr0
done

echo -e "\n\n${magenta}====================RESTRICTING AUTOMATION SERVICES===================="
tput sgr0
sudo touch /etc/at.allow
sudo touch /etc/cron.allow
sudo rm /etc/cron.deny
