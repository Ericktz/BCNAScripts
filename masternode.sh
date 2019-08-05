#!/bin/sh
# Script Contribution
# To Ubuntu Server 18.04
# by DoMato
# Updating
# Donate BCNA: B9bMDqgoAY7XA5bCwiUazdLKA78h4nGyfL
#

check(){
echo "Checking as running as root user"
sleep 1
if [ "root" != "$USER" ]
  then  sudo su -c "$0" root
  exit
fi
}

checkapt(){
echo "Checking packages.."
apt update
apt upgrade -y
apt install -y unzip
}

userad(){
adduser bitcanna
cp /etc/sudoers /etc/oldsudoers
sed '/root    ALL=(ALL:ALL) ALL/a bitcanna  ALL=(ALL:ALL) ALL' /etc/sudoers
}

bcnadown(){
wget https://github.com/BitCannaGlobal/BCNA/releases/download/1.0.0/bcna-1.0.0-unix.zip
mkdir Bitcanna
unzip -xfz bcna-1.0.0-unix.zip -d Bitcanna
}

sync(){
echo "WAIT TO SYNC..."
# FOR cicle to check syncing --> 
.~/Bitcanna/bitcanna-cli getblockchaininfo
}

choice(){
read -n 1 -p "Would you like Configuere STAKE (POS) or MasterNode (MN)? (P/M) " cho;
case $cho in
    p|P)
        stake ;;
    m|M)
        masternode ;;
    *)
        echo "invalid option" ;;
esac
}

masternode(){
}

stake(){
#cd Bitcanna
.~/Bitcanna/bitcannad --daemon && sleep 2 && .~/Bitcanna/bitcanna-cli stop
rm .bitcanna/masternode.conf
"Connecting..."
.~/Bitcanna/bitcannad --daemon
echo "wait... little more..." sleep 10 
sync

}

check
checkapt
userad
su bitcanna && cd ~
bcnadown
choice






