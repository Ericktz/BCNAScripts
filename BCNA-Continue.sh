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
mkdir $BCNAHOME/BACKUP && chmod 770 $BCNAHOME/BACKUP
BCKWLT=$"$BCNADIR/bitcanna-cli backupwallet $BCNAHOME/BACKUP/wallet.dat"
$BCKWLT
echo "Dont be lazy... iTS TO SURE YOU KNOWS YOUR PASSWORD"
read -s -p "PASSPHRASE FOR YOUR WALLET: " WALLETPASS
WLTUNLOCK="$BCNADIR/bitcanna-cli walletpassphrase $WALLETPASS 0 false"
$WLTUNLOCK
WLTADRS=$($BCNADIR/bitcanna-cli getaccountaddress wallet.dat)
BCNADUMP=$($BCNADIR/bitcanna-cli dumpprivkey "$WLTADRS")
echo "Address: $WLTADRS" > $BCNAHOME/BACKUP/wallet.txt
echo "Password: $WALLETPASS" >> $BCNAHOME/BACKUP/wallet.txt
echo "Dump: $BCNADUMP" >> $BCNAHOME/BACKUP/wallet.txt
sleep 0.5
tar -zcvf $BCNAHOME/WalletBackup.tar.gz $BCNAHOME/BACKUP
chmod 500 $BCNAHOME/WalletBackup.tar.gz
echo && echo "WALLET BACKUPED ON: $BCNAHOME/WalletBackup.tar.gz" && echo
echo "!!!!!PLEASE!!!!!SAVE THIS FILE ON MANY DEVICES ON SECURE PLACES!!!!!WHEN SCRIPT FINISH!!!!!!"
read -n 1 -s -r -p "Press any key to continue" 
}

walletposconf(){
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

walletmnconf(){
echo "creatinh new Address for MASTERNODE"
NEWWLTADRS=$BCNADIR/bitcanna-cli getnewaddress “MN1”
echo $NEWWLTADRS
#$NEWWLTADRS

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
rm -rf $BCNAHOME/BACKUP
}

masternode(){
firstrun
#sync
walletmnconf
backup
}

stake(){
firstrun
#sync
walletposconf
backup
}

check
bcnadown
choice
mess
