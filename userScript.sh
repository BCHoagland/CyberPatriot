#!/bin/bash

rootUser=po
users=( po oogway shifu li tigress meimei ping )
admins=( po oogway shifu )

red="\E[1;31m"
green="\E[1;32m"
yellow="\E[1;33m"
blue="\E[1;34m"
magenta="\E[1;35m"

echo -e "${magenta}====================PREP===================="
tput sgr0

#disable guest user
#sudo nano /usr/share/lightdm/lightdm.conf.d/50-ubuntu.conf
sudo nano /etc/lightdm/lightdm.conf

#disable world-readable home directories
sudo dpkg-reconfigure adduser

echo -e "\n\n$magenta====================PARSING USER PROFILES===================="
tput sgr0
for user in `ls /home`; do
	echo -e "${yellow}====================\nCURRENT USER: ${user}\n===================="
	tput sgr0

	containsUser=false
	for userToCompare in ${users[@]}; do
		if [ "$user" == "$userToCompare" ]; then
			containsUser=true
		fi
	done

	#delete or lock unauthorized account
	if [ $containsUser == false ]; then
		echo -e "$red$user is not an authorized user: enter action [del/l]"
		tput sgr0
		read toDo
		if [ "$toDo" == "l" ]; then
			sudo passwd $user -l
			msg="$user locked"
			echo -e "$blue$msg"		#all caps: ${msg^^}
		elif [ "$toDo" == "del" ]; then
			sudo userdel -r $user
			msg="$user deleted"
			echo -e "$blue$msg"
		else
			sudo passwd $user -l
			msg="no action chosen: $user locked"
			echo -e "$blue$msg"
		fi
		tput sgr0

	#check and fix admin permissions and passwords of authorized account
	else
		if [ "$user" != "$rootUser" ]; then
			containsAdmin=false
			for adminToCompare in ${admins[@]}; do
				if [ "$user" == "$adminToCompare" ]; then
					containsAdmin=true
					fi
			done
			if [ $containsAdmin == false ]; then
				sudo deluser $user sudo
				echo -e "${blue}${user}'s admin privileges removed"
				tput sgr0
			fi
			echo "$user:Macintosh21" | sudo chpasswd
			echo -e "${blue}${user}'s password changed"
			sudo chmod 0750 /home/$user
			echo -e "${user}'s home directory no long world-readable"
			tput sgr0
		fi
	fi
done

#add new users
for newUser in ${users[@]}; do
	userIsActive=false
	for activeUser in `ls /home`; do
		if [ "$newUser" == "$activeUser" ]; then
			userIsActive=true
		fi
	done
	if [ "$userIsActive" == false ]; then
		echo -e "${yellow}====================\nCURRENT USER: ${newUser}\n===================="
		tput sgr0
		sudo adduser $newUser
		echo -e "${blue}${newUser} added as a user"
		tput sgr0
	fi
done

echo -e "\n\n${magenta}====================USER SCRIPT COMPLETED===================="
tput sgr0
