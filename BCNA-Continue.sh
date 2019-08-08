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
echo "Connecting..."
echo "wait... more... ~10sec.."
echo "let the baby rest a little xD" && sleep 1
$BCNADIR/bitcannad &
sleep 9
echo "PLEASE WAIT TO FULL SYNCRONIZATION!!!"
echo "Can check opening other session and run"
echo "tail -f $BCNAHOME/.bitcanna/debug.log"
echo "AND search to parameter: progress=1"
echo "1 , means 100% sync.."
read -n 1 -s -r -p "After SYNCED!! Press any key to continue" 

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
echo "staking=0" >> $BCNAHOME/.bitcanna/bitcanna.conf
echo "Connecting..."
echo "wait... more... ~10sec.."
echo "let the baby rest a little xD" && sleep 1
$BCNADIR/bitcannad &
sleep 9
echo "PLEASE WAIT TO FULL SYNCRONIZATION!!!"
echo "Can check opening other session and run"
echo "tail -f $BCNAHOME/.bitcanna/debug.log"
echo "AND search to parameter: progress=1"
echo "1 , means 100% sync.."
read -n 1 -s -r -p "After SYNCED!! Press any key to continue"

echo "Generate your MasterNode Private Key (Need It Later Step-12)"
MNGENK=".$BCNADIR/bitcanna-cli masternode genkey"
echo $MNGENK
#$MNGENK

echo "creating new Address for MASTERNODE- MN0"
NEWWLTADRS="$BCNADIR/bitcanna-cli getnewaddress \“MN0\”"
echo $NEWWLTADRS
#$NEWWLTADRS

echo "TIME TO SEND YOUR COINS TO YOUR MN0 wallet address (check Official Bitcanna.io Claim Guide)"
echo "My MN0 Wallet Address Is:"
WLTADRS=$($BCNADIR/bitcanna-cli getaccountaddress wallet.dat)
echo $WLTADRS
echo "Please wait at least 16+ confirmations of trasaction"
./bitcanna-cli listtransactions


echo "Lets Find the collateral output tx id"
./bitcanna-cli masternode outputs

killall bitcannad
sleep 10
echo "more bitcanna.conf configs..."
echo "externalip=$VPSIP" >> $BCNAHOME/.bitcanna/bitcanna.conf
echo "port=12888" >> $BCNAHOME/.bitcanna/bitcanna.conf


# Example result:
#  0    MN0   2.4.9.8:12888 6CsLuRCaM-fzvvdzYK       06085ec1adb7c3cd33329      1
#Index alias      ip:port   masternode_private_key collateral_transaction_id tx_in-dex
#				step 7			step 10			step 10
#nano ~/.bitcanna/masternode.conf

echo "Run Bitcanna Wallet"
./bitcannad --maxconnections=1000 &

echo "Activate MasterNode"
./bitcanna-cli masternode start-many

## No Reference on Guides about Encrypt ##
##    Maybe cause problems? 
## ohohoh PROTECT YOUR SERVER AND CONNECTION xD
#read -s -p "PASSPHRASE TO/FOR YOUR WALLET: " WALLETPASS
#echo
#WLTPSSCMD=$"$BCNADIR/bitcanna-cli encryptwallet $WALLETPASS"
#$WLTPSSCMD
#WLTUNLOCK="$BCNADIR/bitcanna-cli walletpassphrase $WALLETPASS 0 false|true"
#$WLTUNLOCK
}

mess(){
rm $BCNADIR/bcna_unix_29_07_19
rm -rf $BCNAHOME/BACKUP
rm $BCNAHOME/.bash_history
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
