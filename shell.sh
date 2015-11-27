#!/bin/bash
blue=`tput setaf 6`
red=`tput setaf 1`
reset=`tput sgr0`
function e {
echo ${blue} $1 ${reset}
}
function a {
echo ""
echo ${red} $1 ${reset}
}



cd ~
a "Setup .vimrc..."
echo "set nocompatible" > .vimrc
echo "EDITOR=vi
export EDITOR" >> .profile
source .profile

a "Download .bashrc? [y/n] "
read -p " " yn
case $yn in
	yY) mv .bashrc .bak-bashrc  && wget http://mindnugget.com/bashrc/.bashrc && wget http://mindnugget.com/bashrc/.bashrc_help;;
	*) e "No external .bashrc" ;;
	esac

a "Setup .bashrc..."
echo "mcd() { mkdir \"$1\"; cd \"$1\"; }
mccd() { mkdir -P \"$1\"; cd \"$1\"; }
alias ll='ls -ahl'
alias ..=cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias i='sudo apt-get install'
bak(){ mv \"$1\" \"$1.bak\"; cp \"$2\" \"$1\"; }" >> .bashrc
source .bashrc



a "Install...."
sudo apt-get install ncdu \
git \
wget \
unzip 

a "Update System?"
e "1: sudo apt-get -y update"
e "2: sudo yum -y update"
read -p "3: do nothing " yn
case $yn in
 1) sudo apt-get update ;;
 2) sudo yum -y update ;;
 *) ;;
esac 
e "Add Public SSH Key"
mkdir .ssh
echo "ssh-rsa AAAAB3NzaC1yc2EAAAABJQAAAQEAimIvph2gT6wudQGlyWKIcP/m3RZa+mMzapdRQwTwSbdFtSl2LnL7NvMK4JDLweNc8KX3YyMyJQb0XeyHGWgG0Mc5Wd3rOAblW/uOHd6vzaHlDUFIldxwd9ibVShTIc/HAdKqlxqt8DbXN2pBLw75uFLvMaxCzfte7kyz9ALfF63xgWBqGKIC/6woFJWIuByvCZtDBN3gwf6scXQwtHWTBEXH3wpOf2+47faoKD1L7y0D7lYtBENkBYq7QJb9uUO7HMAa7d5WR5hPniwpySfg3Jp5AqM89ZVuQHfuzN4k/PpE1XnL2I1eNS7CntvU5l4lCnabF402ytGEhpNPybUVAQ== rsa-key-20151122" > .ssh/authorized_keys2
chmod 700 .ssh
chmod 600 .ssh/authorized_keys2

a "Network Config"
e "1: Debian-style (/etc/network/interfaces)"
e "2: Redhat-style (/etc/sysconfig/network-scripts/ifcfg-ethX)"
e "No network config"
read -p "Choose wisely: " networkconfig
case $networkconfig in
	1)
		e "1: add 192.168.1.112 (gateway 192.168.1.1) on eth0"
		e "2: add 192.168.1.??? (gateway 192.168.1.1) on eth0"
		e "3: manual config"
		read -p "Choose wisely: " ipchange
		case $ipchange in
		 1) sudo cp /etc/network/interfaces /etc/network/interfaces.bak
		 e "Writing the following to /etc/network/interfaces"
		echo 'auto eth0
iface eth0 inet static
address 192.168.1.112
netmask 255.255.255.0
gateway 192.168.1.1' | sudo tee /etc/network/interfaces ;;
		 2) read -p "Enter IP (192.168.1.???): " ip 
			 sudo cp /etc/network/interfaces /etc/network/interfaces.bak
			echo "auto eth0
iface eth0 inet static
address 192.168.1.$ip
netmask 255.255.255.0
gateway 192.168.1.1" | sudo tee /etc/network/interfaces ;;
		3)  read -p "Enter IP (e.g. 192.168.1.2): " ip
			read -p "Enter Gateway IP Address: " gateway
			read -p "Enter Ethernet Device (e.g. eth0): " device
			sudo cp /etc/network/interfaces /etc/network/interfaces.bak
			e "Writing the following to /etc/network/interfaces"
                        echo "auto $device
iface $device inet static
address $ip
netmask 255.255.255.0
gateway $gateway" | sudo tee /etc/network/interfaces ;;
 
		*) e "No valid choice" ;;
		esac;;
	2)	e "Not yet implemented";;
	*)	e "Ok, no change in network config"
		
	esac
