#!/bin/sh
# Script Contribution
# To Ubuntu Server 18.04
# by DoMato
# Updating
# Donate BCNA: B9bMDqgoAY7XA5bCwiUazdLKA78h4nGyfL
#
varys(){
# Starting "variabling"
BCNAPKG=bcna-1.0.0-unix.zip
}

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
apt update && apt upgrade -y apt install -y unzip
}

userad(){
echo "Creating bitcanna user and add to sudoers"
adduser bitcanna
cp /etc/sudoers /etc/oldsudoers
if [ -f "/etc/sudoers.tmp" ]; then
    exit 1
fi
cp /etc/sudoers /etc/sudoers.tmp
sed '/root    ALL=(ALL:ALL) ALL/a bitcanna  ALL=(ALL:ALL) ALL' /tmp/sudoers.new
visudo -c -f /tmp/sudoers.new
if [ "$?" -eq "0" ]; then
    cp /tmp/sudoers.new /etc/sudoers
fi
rm /etc/sudoers.tmp
rm /etc/oldsudoers
}

bcnadown(){
wget https://github.com/BitCannaGlobal/BCNA/releases/download/1.0.0/$BCNAPKG
mkdir Bitcanna
unzip -xfz $BCNAPKG -d Bitcanna
}

sync(){
echo "WAIT TO SYNC..."
# FOR cicle to check syncing --> 
tail -f ~/.bitcanna/debug.log | grep 'process=1' | read -t 15 dummyvar
[ $dummyvar -eq 0 ]  && echo 'Bitcanna Wallet Fully Synced!!!' || echo 'Wait... Wallet are syncing' ; .~/Bitcanna/bitcanna-cli getinfo
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

firstrun(){
#cd Bitcanna
.~/Bitcanna/bitcannad --daemon && sleep 2 && .~/Bitcanna/bitcanna-cli stop
rm .bitcanna/masternode.conf
"Connecting..."
.~/Bitcanna/bitcannad --daemon
echo "wait... little more..." sleep 10
}

service(){
echo "!!!!DO THIS NEEDS STOP THE WALLET!!!!!"
read -p "You want set Bitcanna Run as Server Booting? [Y/N]" answer
if [[ $answer = y ]] ; then
 ~/Bitcanna/bitcanna-cli stop
 cat << EOF > /lib/systemd/system/bitcanna.service
[Unit]
Description=BCNA's distributed currency daemon EDITED by hellrezistor
After=network.target
[Service]
User=bitcanna
Group=bitcanna
Type=forking
PIDFile=/var/lib/bitcannad/bitcannad.pid
### THIS ARE ALL WROONNGG :DDD ####
ExecStart=/home/bitcanna/Bitcanna/bitcannad -daemon -pid=/home/bitcanna/.bitcanna/bitcannad.pid \
          -conf=/home/bitcanna/.bitcanna/bitcanna.conf -datadir=/home/bitcanna/.bitcanna
ExecStop=-/home/bitcanna/Bitcanna/bitcanna-cli stop -conf=/home/bitcanna/.bitcanna/bitcanna.conf \
         -datadir=/home/bitcanna/.bitcanna
Restart=always
PrivateTmp=true
TimeoutStopSec=60s
TimeoutStartSec=2s
StartLimitInterval=120s
StartLimitBurst=5
[Install]
WantedBy=multi-user.target
 EOF
 systemctl enable bitcannad
 systemctl start bitcannad
 systemctl status bitcannad
fi
}

backup(){
mkdir ~/home/bitcanna/BACKUP && chmod 700 ~/home/bitcanna/BACKUP
~/Bitcanna/bitcanna-cli backupwallet ~/home/bitcanna/BACKUP
~/Bitcanna/bitcanna-cli dumpprivkey $WALLETADDRESS
~/Bitcanna/bitcanna-cli backupwallet dumpwallet wallet.dat
echo "$walletpass" >> ~/home/bitcanna/BACKUP/password.txt
tar -czvf ~/home/bitcanna/WalletBackup.tar.gz ~/home/bitcanna/BACKUP
chmod 500 ~/home/bitcanna/WalletBackup.tar.gz
echo && echo "WALLET BACKUPED ON: ~/home/bitcanna/WalletBackup.tar.gz && echo
echo "!!!!!PLEASE!!!!!SAVE THIS FILE ON MANY DEVICES ON SECURE PLACES!!!!!WHEN SCRIPT FINISH!!!!!!"1
sleep 3
cd ~/home/bitcanna/ && echo pwd && ls -a
read -n 1 -s -r -p "Press any key to continue" 
}

walletconf(){
echo "Lets Generate your Address"
~/Bitcanna/bitcanna-cli getnewaddress wallet.dat
WALLETADDRESS='~/Bitcanna/bitcanna-cli getaddressesbyaccount wallet.dat'
echo "My Wallet Address Is:"
echo $WALLETADDRESS
echo "ENCRYPT YOUR WALLET WITH PASSPHRASE"
read walletpass
~/Bitcanna/bitcanna-cli walletpassphrase $walletpass
}

masternode(){
firstrun
sync
walletconf
service

backup
}

stake(){
firstrun
sync
walletconf
service

backup
}

check
checkapt
userad
su bitcanna && cd ~
bcnadown
choice






