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

startup(){
echo "!!!!DO THIS NEEDS STOP THE WALLET!!!!!"
read -p "You want set Bitcanna Run as Server Booting? [Y/N]" answer
if [[ $answer = y ]] ; then
 ~/Bitcanna/bitcanna-cli stop
 cat <<EOF > /lib/systemd/system/bitcanna.service
[Unit]
Description=BCNA's distributed currency daemon
After=network.target
[Service]
User=bitcanna
Group=bitcanna
Type=forking
PIDFile=/var/lib/bitcannad/bitcannad.pid
### THIS ARE ALL WROONNGG :DDD ####
ExecStart=/usr/bin/bitcannad -daemon -pid=/var/lib/bitcannad/bitcannad.pid \
          -conf=/etc/bitcanna/bitcanna.conf -datadir=/var/lib/bitcannad
ExecStop=-/usr/bin/bitcanna-cli -conf=/etc/bitcanna/bitcanna.conf \
         -datadir=/var/lib/bitcannad stop
Restart=always
PrivateTmp=true
TimeoutStopSec=60s
TimeoutStartSec=2s
StartLimitInterval=120s
StartLimitBurst=5
[Install]
WantedBy=multi-user.target
 EOF
 systemctl enable bitcoind
 systemctl start bitcoind
 systemctl status bitcoind
fi


}

walletconf(){
echo "Lets Generate your Address"
~/Bitcanna/bitcanna-cli getnewaddress wallet.dat
~/Bitcanna/bitcanna-cli getaddressesbyaccount wallet.dat
echo "ENCRYPT YOUR WALLET WITH PASSPHRASE"
read walletpass
~/Bitcanna/bitcanna-cli walletpassphrase $walletpass
}

masternode(){
firstrun
sync
walletconf
startup
}

stake(){
firstrun
sync
walletconf
startup
}

check
checkapt
userad
su bitcanna && cd ~
bcnadown
choice






