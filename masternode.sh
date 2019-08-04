#!/bin/sh
# Script Contribution
# To Ubuntu Server 18.04
# by DoMato
# Updating
echo "Run as root!"

#Add bitcanna user
sudo adduser bitcanna
sudo visudo 
sudo cp /etc/sudoers /etc/oldsudoers
sed '/root    ALL=(ALL:ALL) ALL/a bitcanna  ALL=(ALL:ALL) ALL' file /etc/sudoers
su bitcanna
cd /home/bitcanna
wget https://github.com/BitCannaGlobal/BCNA/releases/download/1.0.0/bcna-1.0.0-unix.zip
mkdir Bitcanna
mkdir .bitcanna
unzip -xfz bcna-1.0.0-unix.zip -d Bitcanna
cd Bitcanna
sudo ./bitcannad
