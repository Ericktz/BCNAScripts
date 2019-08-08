#!/bin/bash
# Script Contribution to BitCanna Community
# CONTINUE...
#

BCNAUSER="bitcanna"
BCNAPKG="bcna-1.0.0-unix.zip"
BCNAHOME="/home/$BCNAUSER"
BCNADIR="$BCNAHOME/Bitcanna"
STAKE="100"

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
## Failing not work... more time to dedicated a miscellinous
tail -f .bitcanna/debug.log | grep --line-buffered 'process=1' | read -t 15 dummyvar
[ $dummyvar -eq 0 ]  && echo 'Bitcanna Wallet Fully Synced!!!' || echo 'Wait... Wallet are syncing' ; Bitcanna/bitcanna-cli getinfo
}

choice(){
read -n 1 -p "Would you like Configure STAKE (POS) or MasterNode (MN)? (P/M) " cho;
case $cho in
    p|P) echo && echo && echo "Stake (POS) Installation Choosed" && sleep 0.5 && stake  ;;
    m|M) masternode ;;
    *)
        echo "invalid option" ;;
esac
}

firstrun(){
echo "COPY the rpcuser=bitcannarpc and rpcpassword=xxxxxx......"
$BCNADIR/bitcannad --daemon && sleep 6
echo
echo "NOW!! PASTE THE line of rpcuser=xxx"
read RPCUSR
echo "NOW!! PASTE THE line of rpcpassword=xxxxxxxx..."
read RPCPWD
echo $RPCUSR >> $BCNAHOME/.bitcanna/bitcanna.conf
echo $RPCPWD >> $BCNAHOME/.bitcanna/bitcanna.conf
chmod 777 $BCNAHOME/.bitcanna/masternode.conf
rm $BCNAHOME/.bitcanna/masternode.conf
echo "Connecting..."
$BCNADIR/bitcannad &
read -n 1 -s -r -p "READ the RESULT ... Press any key to continue"
echo "wait... little more..."
sleep 10
}

backup(){
mkdir $BCNAHOME/BACKUP && chmod 700 $BCNAHOME/BACKUP
$BCNADIR/bitcanna-cli backupwallet $BCNAHOME/BACKUP
$BCNADIR/bitcanna-cli dumpprivkey $WALLETADDRESS
$BCNADIR/bitcanna-cli backupwallet dumpwallet wallet.dat
echo "$WLTADRS" >> $BCNAHOME/BACKUP/password.txt
echo "$WALLETPASS" >> $BCNAHOME/BACKUP/password.txt
echo "$RPCUSER" >> $BCNAHOME/BACKUP/rpc.txt
echo "$RPCPWD" >> $BCNAHOME/BACKUP/rpc.txt
tar -czvf $BCNAHOME/WalletBackup.tar.gz $BCNAHOME/BACKUP
chmod 500 $BCNAHOME/WalletBackup.tar.gz
echo && echo "WALLET BACKUPED ON: $BCNAHOME/WalletBackup.tar.gz" && echo
echo "!!!!!PLEASE!!!!!SAVE THIS FILE ON MANY DEVICES ON SECURE PLACES!!!!!WHEN SCRIPT FINISH!!!!!!"
sleep 3
cd $BCNAHOME && echo pwd && ls -a
read -n 1 -s -r -p "Press any key to continue" 
}

walletconf(){
echo "My Wallet Address Is:"
WLTADRS=$($BCNADIR/bitcanna-cli getaccountaddress wallet.dat)
echo $WLTADRS
read -s -p "PASSPHRASE TO/FOR YOUR WALLET: " WALLETPASS
echo
WLTPSSCMD=$"$BCNADIR/bitcanna-cli encryptwallet $WALLETPASS"
$WLTPSSCMD
WLTUNLOCK="$BCNADIR/bitcanna-cli walletpassphrase $WALLETPASS 0 true"
$WLTUNLOCK
WLTSTAKE="$BCNADIR/bitcanna-cli setstakesplitthreshold $STAKE"
$WLTSTAKE
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
#firstrun
#sync
walletconf
#backup
read -n 1 -s -r -p "Press any key to continue" 
}

#check
#bcnadown
choice
#mess
