#!/bin/bash
# Script Contribution to BitCanna Community
# CONTINUE...
#

BCNAUSER=bitcanna
BCNAPKG=bcna-1.0.0-unix.zip
BCNAHOME=/home/$BCNAUSER
BCNADIR=$BCNAHOME/Bitcanna
STAKE=100

echo "BitCanna Comunity Script by Hellresistor aKa domato "
echo

check(){
echo "Checking as running as bitcanna user"
sleep 0.5
if [ "$BCNAUSER" != "$USER" ]
  then  sudo su -c "$0" "$BCNAUSER"
  exit
fi
}

bcnadown(){
# yyeeaahh.. I know.. i will do that work nicee pretty
wget -P $BCNAHOME https://github.com/BitCannaGlobal/BCNA/releases/download/1.0.0/$BCNAPKG
mkdir $BCNADIR
unzip $BCNAHOME/$BCNAPKG -d $BCNADIR
mv $BCNADIR/bcna_unix_29_07_19/* $BCNADIR
chmod -R 777 $BCNADIR
rm -rf $BCNADIR/*/ && rm $BCNAHOME/$BCNAPKG
}

sync(){
echo "WAIT TO SYNC..."
## A cicle to check syncing...
tail -f $BCNAHOME/.bitcanna/debug.log | grep 'process=1' | read -t 5 dummyvar
[ $dummyvar -eq 0 ]  && echo 'Bitcanna Wallet Fully Synced!!!' || echo 'Wait... Wallet are syncing' ; .$BCNADIR/bitcanna-cli getinfo
}

choice(){
read -n 1 -p "Would you like Configure STAKE (POS) or MasterNode (MN)? (P/M) " cho;
case $cho in
    p|P) echo "Stake (POS) Installation Choosed" && sleep 0.5 && stake  ;;
    m|M) masternode ;;
    *)
        echo "invalid option" ;;
esac
}

firstrun(){
#mkdir $BCNAHOME/.bitcanna
#touch $BCNAHOME/.bitcanna/bitcanna.conf
#chmod 0660 $BCNAHOME/.bitcanna/bitcanna.conf
#$BCNADIR/bitcannad --daemon 
$BCNADIR/bitcanna-cli stop
sleep 5
chmod 777 $BCNAHOME/.bitcanna/masternode.conf
rm $BCNAHOME/.bitcanna/masternode.conf
echo "Connecting..."
#$BCNADIR/bitcannad --daemon &
read -n 1 -s -r -p "READ the RESULT ... Press any key to continue"
echo "wait... little more..."
sleep 10
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
.$BCNADIR/bitcanna-cli getnewaddress wallet.dat
WALLETADDRESS='.$BCNADIR/bitcanna-cli getaddressesbyaccount wallet.dat'
echo "My Wallet Address Is:"
echo $WALLETADDRESS
echo "ENCRYPT YOUR WALLET WITH PASSPHRASE"
read WALLETPASS
.$BCNADIR/bitcanna-cli walletpassphrase $WALLETPASS
}

mess(){
rm $BCNADIR/bcna_unix_29_07_19
}

masternode(){
echo
#firstrun
#sync
#walletconf
#backup
}

stake(){
firstrun
#sync
#walletconf
#$BCNADIR/bitcanna-cli setstakesplitthreshold $STAKE
#backup
read -n 1 -s -r -p "Press any key to continue" 
}

#check
#bcnadown
choice
#mess
