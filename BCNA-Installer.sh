#!/bin/bash
# Script Contribution to BitCanna Community
# To Ubuntu Server 18.04
#
# STATUS: Developing
#
# by DoMato aka hellresistor
# Donate BCNA: B9bMDqgoAY7XA5bCwiUazdLKA78h4nGyfL
#

varys(){
# Starting "variabling"
BCNAPKG=bcna-1.0.0-unix.zip
BCNAHOME=/home/bitcanna
BCNADIR='$BCNAHOME/Bitcanna'
STAKE='100'
}

check(){
echo "Checking as running as root user"
sleep 1
if [ "root" != "$USER" ]
  then  sudo su -c "$0" root
  exit
fi
}

userad(){
echo "Creating bitcanna user and add to sudoers"
adduser bitcanna
cp /etc/sudoers /etc/sudoers.bck
echo ":( :( Soorrryy You need do it by hand :( :( :(" && sleep 1 && echo && sleep 1 && echo
echo "!!!!!!!!!!!!!!!! COPY THIS LINE BELOW !!!!!!!!!!!!!!!!" && echo && echo && sleep 1
echo "bicanna	ALL=(ALL:ALL) ALL" && echo && echo && sleep 1
echo "You need PASTE THAT above of this line: root	ALL=(ALL:ALL) ALL"
read -n 1 -s -r -p "Press any key to continue to VISUDO"
visudo
}

login(){
sudo -u bitcanna bash << EOF
echo "In"
whoami
echo "smells me ... cant pass vars :D work'n'it"
EOF
}

bcnadown(){
wget https://github.com/BitCannaGlobal/BCNA/releases/download/1.0.0/$BCNAPKG
mkdir Bitcanna
unzip -xfz $BCNAPKG -d Bitcanna
}

sync(){
echo "WAIT TO SYNC..."
# FOR cicle to check syncing --> 
tail -f $BCNAHOME/.bitcanna/debug.log | grep 'process=1' | read -t 5 dummyvar
[ $dummyvar -eq 0 ]  && echo 'Bitcanna Wallet Fully Synced!!!' || echo 'Wait... Wallet are syncing' ; .$BCNADIR/bitcanna-cli getinfo
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
.$BCNADIR/bitcannad --daemon && sleep 2 && .$BCNADIR/bitcanna-cli stop
rm $BCNAHOME/.bitcanna/masternode.conf
echo "Connecting..."
.$BCNADIR/bitcannad --daemon
echo "wait... little more..." sleep 10
}

service(){
echo "!!!!DO THIS NEEDS STOP THE WALLET!!!!!"
read -p "You want set Bitcanna as Run a service on startup? [y/n]" answer
if [[ $answer = y ]] ; then
 $BCNADIR/bitcanna-cli stop
( 
cat <<AIAI 
 [Unit]
 Description=BCNAs distributed currency daemon EDITED by hellresistor
 After=network.target
 [Service]
 User=bitcanna
 Group=bitcanna
 Type=forking
 PIDFile=/var/lib/bitcannad/bitcannad.pid
 ExecStart=$BCNADIR/bitcannad -daemon -pid=$BCNAHOME/.bitcanna/bitcannad.pid \
          -conf=$BCNAHOME/.bitcanna/bitcanna.conf -datadir=$BCNAHOME/.bitcanna
 ExecStop=$BCNADIR/bitcanna-cli stop -conf=$BCNAHOME/.bitcanna/bitcanna.conf \
         -datadir=$BCNAHOME/.bitcanna
 Restart=always
 PrivateTmp=true
 TimeoutStopSec=60s
 TimeoutStartSec=2s
 StartLimitInterval=120s
 StartLimitBurst=5
 [Install]
 WantedBy=multi-user.target
AIAI
) > /tmp/bitcanna.service
cp /tmp/bitcanna.service /lib/systemd/system/bitcanna.service
sudo systemctl enable bitcannad
sudo systemctl start bitcannad
sudo systemctl status bitcannad
fi
}

backup(){
mkdir $BCNAHOME/BACKUP && chmod 700 $BCNAHOME/BACKUP
$BCNADIR/bitcanna-cli backupwallet $BCNAHOME/BACKUP
$BCNADIR/bitcanna-cli dumpprivkey $WALLETADDRESS
$BCNADIR/bitcanna-cli backupwallet dumpwallet wallet.dat
echo "$walletpass" >> $BCNAHOME/BACKUP/password.txt
tar -czvf $BCNAHOME/WalletBackup.tar.gz $BCNAHOME/BACKUP
chmod 500 $BCNAHOME/WalletBackup.tar.gz
echo && echo "WALLET BACKUPED ON: $BCNAHOME/WalletBackup.tar.gz" && echo
echo "!!!!!PLEASE!!!!!SAVE THIS FILE ON MANY DEVICES ON SECURE PLACES!!!!!WHEN SCRIPT FINISH!!!!!!"
sleep 3
cd $BCNAHOME && echo pwd && ls -a
read -n 1 -s -r -p "Press any key to continue" 
}

walletconf(){
echo "Lets Generate your Address"
$BCNADIR/bitcanna-cli getnewaddress wallet.dat
WALLETADDRESS='$BCNADIR/bitcanna-cli getaddressesbyaccount wallet.dat'
echo "My Wallet Address Is:"
echo $WALLETADDRESS
echo "ENCRYPT YOUR WALLET WITH PASSPHRASE"
read walletpass
$BCNADIR/bitcanna-cli walletpassphrase $walletpass
}

mess(){
rm /etc/sudoers.tmp
rm /etc/oldsudoers
rm /tmp/bitcanna.service
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
$BCNADIR/bitcanna-cli setstakesplitthreshold $STAKE
service
backup
}

check
userad
login
bcnadown
choice
mess






