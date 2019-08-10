#!/bin/bash
intro{
cat<< EOF
##################################################################################
##                   Script Contribution to BitCanna Community                  ##
##                           To Ubuntu 18.04 LTS Server                         ##
##################################################################################
##                                                                              ##
##                               STEP 2 and LAST                                ##
##                                                                              ##
##################################################################################
EOF
echo "Continue this Script are Accepting you are the only responsible"
read -n 1 -s -r -p "Press any key to Executing this Script" 
}
BCNAPKG=bcna-1.0.0-unix.zip
BCNAHOME=/home/$BCNAUSER
BCNACONF=$BCNAHOME/.bitcanna
BCNADIR=$BCNAHOME/Bitcanna
STAKE="100"
check(){
echo "###########################################" && echo "## Checking If script is running as $BCNAUSER ##" && echo "###########################################" && sleep 1
sleep 0.5
if [ "$BCNAUSER" != \"$USER\" ]
  then  sudo su -c \"$0\" "$BCNAUSER"
  exit
fi
echo "#########################################" && echo "## You are $BCNAUSER ! Will Continue! wait.. ##" && echo "#########################################" && sleep 2
}
bcnadown(){
clear
echo "###############################################################" && echo "## Lets Download and Extract the Bitcanna Wallet from GitHub ##" && echo "###############################################################"
# yyeeaahh.. I know.. i will do that work nicee pretty 
wget -P $BCNAHOME https://github.com/BitCannaGlobal/BCNA/releases/download/1.0.0/$BCNAPKG
mkdir $BCNADIR && unzip $BCNAHOME/$BCNAPKG -d $BCNADIR && mv $BCNADIR/bcna_unix_29_07_19/* $BCNADIR
chmod -R 777 $BCNADIR && rm -rf $BCNADIR/*/ && rm $BCNAHOME/$BCNAPKG
echo "###########################################" && echo "## Downloaded and Extracted to: $BCNADIR ##" && echo "###########################################" && sleep 1
}

sync(){
## Working on this .. dont get the mach from file .. missing syntax or like that 
echo "WAIT TO SYNC..."
tail -n 0 -F .bitcanna/debug.log | grep "progress=0.032010" | read -t 5 dummyvar
if [ $dummyvar -eq 0 ] 
 echo "Bitcanna Wallet Fully Synced!!!"
then
 echo "Wait... Wallet are syncing" 
fi
# ; ./home/bitcanna/Bitcanna/bitcanna-cli getinfo
## Other way ...
# tail -n 0 -F /home/bitcanna/.bitcanna/debug.log | while read dummyvar
# do
# echo "$dummyvar" | grep "progress=0.032"
# if [ $dummyvar = 0 ]
# then
# echo "Wallet Synced" || echo "Wallet Syncing... w8" 
# fi
# done
## Getting loop of ' ./BCNA-Continue.sh: line 43: [: too many arguments '
# much info inside file
echo "Continuou"
}
choice(){
clear
echo "#######################################" && echo "## BitCanna Wallet Installation Menu ##" && echo "#######################################"
read -n 1 -p "Would you like Configure STAKE (POS) or MasterNode (MN)? (P/M): " choiz;
case $choiz in
    p|P) echo "########################################" && echo "## Selected Stake - POS Configuration ##" && echo "########################################" && sleep 0.5 && stake  ;;
    m|M) echo "############################################" && echo "## Selected MasterNode - MN Configuration ##" && echo "############################################" && sleep 0.5 && masternode ;;
    *) echo "####################" && echo "## Invalid Option ##" && echo "####################" && sleep 0.5 ;;
esac
}
firstrun(){
clear
echo "######################################" && echo "## Lets Initiate configurations ... ##" && echo "######################################"
sleep 0.5 && $BCNADIR/bitcannad & && sleep 10
cat<<EIF
##########################################
## COPY the Returned values (example):  ##
##        rpcuser=criptouser            ##
##        rpcpassword=abcdefg           ##
##########################################
##########################################
## PASTE the line of rpcuser=criptouser ##
##########################################
EIF
read RPCUSR && echo "###########################################" && echo "## PASTE the line of rpcpassword=abcdefg ##"
echo "###########################################" && read RPCPWD && echo $RPCUSR >> $BCNACONF/bitcanna.conf && echo $RPCPWD >> $BCNACONF/bitcanna.conf
rm $BCNACONF/masternode.conf && echo "#################################" && echo "## Initial Configurations Done ##" && echo "#################################"
}
backup(){
clear
echo "###########################" && echo "## Backuping Wallet Info ##" && echo "###########################"
mkdir $BCNAHOME/BACKUP && chmod 770 $BCNAHOME/BACKUP
BCKWLT=$"$BCNADIR/bitcanna-cli backupwallet $BCNAHOME/BACKUP/wallet.dat"
$BCKWLT
#echo "Dont be lazy... iTS TO SURE YOU KNOWS YOUR PASSWORD"
#read -s -p "PASSPHRASE FOR YOUR WALLET: " WALLETPASS
#WLTUNLOCK="$BCNADIR/bitcanna-cli walletpassphrase $WALLETPASS 0 false"
#$WLTUNLOCK
#WLTADRS=$($BCNADIR/bitcanna-cli getaccountaddress wallet.dat)
BCNADUMP=$($BCNADIR/bitcanna-cli dumpprivkey "$WLTADRS")
cat<<EOF > $BCNAHOME/BACKUP/walletinfo.txt
Address: $WLTADRS
Password: $WALLETPASS
Dump: $BCNADUMP
$RPCUSER
$RPCPWD
EOF
tar -zcvf $BCNAHOME/WalletBackup.tar.gz $BCNAHOME/BACKUP && chmod 500 $BCNAHOME/WalletBackup.tar.gz
cat<<EOF
############################################################
## Info Wallet Backuped in: $BCNAHOME/WalletBackup.tar.gz ##
## !!!PLEASE!!! SAVE THIS FILE ON MANY DEVICES ON SECURE  ##
############################################################
EOF
read -n 1 -s -r -p "Press any key to Finish" 
}

cryptwallet(){
cat<<ETF
########################################################
## No Reference on Guides about Encrypt on MasterNode ##
##              Maybe cause problems?                 ##
##               PROTECT YOUR Server                  ##
########################################################
ETF
read -s -p "Set PassPhrase to wallet.dat: " WALLETPASS
WLTPSSCMD=$"$BCNADIR/bitcanna-cli encryptwallet $WALLETPASS"
$WLTPSSCMD && sleep 5
if [ "$choiz" == "p" || "$choiz" == "P" ]
 then
  echo "############################" && echo "## Set to Staking forever ##" && echo "############################" && sleep 0.5
  WLTUNLOCK="$BCNADIR/bitcanna-cli walletpassphrase $WALLETPASS 0 true"
  $WLTUNLOCK
  WLTSTAKE="$BCNADIR/bitcanna-cli setstakesplitthreshold $STAKE"
  $WLTSTAKE
  echo "##############" && echo "## Staking! ##" && echo "##############" && sleep 0.5
 fi
}

syncbasic(){
clear
cat<<OFT
##############################################
##      __   __     _____   ______          ##
##     /__/\/__/\  /_____/\/_____/\         ##
##     \  \ \: \ \_\:::_:\ \:::_ \ \        ##
##      \::\_\::\/_/\  _\:\|\:\ \ \ \       ##
##       \_:::   __\/ /::_/__\:\ \ \ \      ##
##            \::\ \  \:\____/\:\_\ \ \     ##      
##             \__\/   \_____\/\_____\/     ##
##   T I M E                                ##
##############################################
## !!!PLEASE WAIT TO FULL SYNCRONIZATION!!! ##
## Can check opening other session and run: ##
##                                          ##
## tail -f $BCNAHOME/.bitcanna/debug.log    ##
##                                          ##
## AND search&wait to parameter: progress=1 ##
##############################################
##     (1) means 100% of Syncronization     ##
##############################################
OFT
read -n 1 -s -r -p "After SYNCED!! Press any key to continue (3)" 
echo "####################" && echo "## You SURE ?!?!? ##" && echo "####################"
read -n 1 -s -r -p "After SYNCED!! Press any key to continue (2)"
echo "################################" && echo "## Wait the Time what It NEED ##" && echo "################################"
read -n 1 -s -r -p "After SYNCED!! Press any key to continue (1)"
echo "#########################################" && echo "## OK! OK! OK! I know.. Its ANNOYING!! ##" && echo "#########################################"
read -n 1 -s -r -p "OK! ARE SYNCED!! Press any key to continue (OYEAH!!)" 
}

walletposconf(){
clear && echo "## Connecting ... ## && sleep 0.4 && $BCNADIR/bitcannad & && sleep 9 && syncbasic
clear && echo "###########################" && echo "## My Wallet Address Is: ##" && echo "###########################"
WLTADRS=$($BCNADIR/bitcanna-cli getaccountaddress wallet.dat) && echo $WLTADRS && cryptwallet
echo "################################################################################"
echo "## CONGRATULATIONS!! BitCanna POS - Proof-Of-Stake Configurrations COMPLETED! ##"
echo "################################################################################"
sleep 1
}

walletmnconf(){
echo "staking=0" >> $BCNAHOME/.bitcanna/bitcanna.conf
read -s "Set Yous MasterNode Alias (usually: MN1): " MNALIAS
echo "Connecting..."
echo "wait... more... ~10sec.."
echo "let the baby rest a little xD" && sleep 1
$BCNADIR/bitcannad &
sleep 9
syncbasic
echo "Generate your MasterNode Private Key (Need It Later Step-12)"
MNGENK=".$BCNADIR/bitcanna-cli masternode genkey"
echo $MNGENK
#$MNGENK
echo "creating new Address for MASTERNODE - $MNALIAS"
NEWWLTADRS="$BCNADIR/bitcanna-cli getnewaddress \“$MNALIAS\”"
echo $NEWWLTADRS
#$NEWWLTADRS
echo "TIME TO SEND YOUR COINS TO YOUR MN0 wallet address (check Official Bitcanna.io Claim Guide)"
echo "My $MNALIAS Wallet Address Is:"
WLTADRS=$($BCNADIR/bitcanna-cli getaccountaddress wallet.dat)
echo $WLTADRS
echo "Please wait at least 16+ confirmations of trasaction"
echo
read -n 1 -s -r -p "After 16+ confirmations, Press any key to continue to lists"
./$BCNAHOME/bitcanna-cli listtransactions
echo "Copy respectiv the txID?!?!?"
read -s "Copy respectiv transfer txID?!?!?" TXID
echo "Lets Find the collateral output tx and index"
./$BCNADIR/bitcanna-cli masternode outputs
read -s "Set the long part (tx) string" MNTX
read -s "Set the short part (id) string" MNID
killall bitcannad && sleep 10
echo "Get VPS IP..."
VPSIP="$(dig +short myip.opendns.com @resolver1.opendns.com)"
echo "more bitcanna.conf configs..."
echo "externalip=${VPSIP}" >> $BCNAHOME/.bitcanna/bitcanna.conf
echo "port=12888" >> $BCNAHOME/.bitcanna/bitcanna.conf
read -s "Number of this Masternode. Default: 0 (Zer0 - To First Node, 1 - To 2nd node)" IDMN
cat <<EOF
# Example result:
0 MN1 72.46.79.228:12888 6CsM56RjQbL4vdLuRCaM-fvdzYK 109e49adb637ed-d206c3cd33329 1
Nº Alias	IP:Port		step 7			    step 10		  step 10
#nano ~/.bitcanna/masternode.conf
EOF
sed "$IDMN $MNALIAS $VPSIP:12888 $MNGENK $MNTX $MNID" $BCNAHOME/.bitcanna/masternode.conf
cat  $BCNAHOME/.bitcanna/masternode.conf
sleep 1
echo "Run Bitcanna Wallet"
.$BCNAHOME/bitcannad --maxconnections=1000 &
echo "Activate MasterNode"
.$BCNAHOME/bitcanna-cli masternode start-many
cryptwallet
}

mess(){
echo "#########################" && echo "## Cleaning the things ##" && echo "#########################"
rm $BCNADIR/bcna_unix_29_07_19
rm -rf $BCNAHOME/BACKUP
rm $BCNAHOME/.bash_history
rm $BCNAHOME/$BCNAPKG
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
clear
cat<<FOH
################################################################################################################
##   ▄▄▄▄▄▄▄▄▄▄   ▄▄▄▄▄▄▄▄▄▄▄  ▄▄▄▄▄▄▄▄▄▄▄  ▄▄▄▄▄▄▄▄▄▄▄  ▄▄▄▄▄▄▄▄▄▄▄  ▄▄        ▄  ▄▄        ▄  ▄▄▄▄▄▄▄▄▄▄▄   ##
##  ▐░░░░░░░░░░▌ ▐░░░░░░░░░░░▌▐░░░░░░░░░░░▌▐░░░░░░░░░░░▌▐░░░░░░░░░░░▌▐░░▌      ▐░▌▐░░▌      ▐░▌▐░░░░░░░░░░░▌  ##
##  ▐░█▀▀▀▀▀▀▀█░▌ ▀▀▀▀█░█▀▀▀▀  ▀▀▀▀█░█▀▀▀▀ ▐░█▀▀▀▀▀▀▀▀▀ ▐░█▀▀▀▀▀▀▀█░▌▐░▌░▌     ▐░▌▐░▌░▌     ▐░▌▐░█▀▀▀▀▀▀▀█░▌  ##
##  ▐░▌       ▐░▌     ▐░▌          ▐░▌     ▐░▌          ▐░▌       ▐░▌▐░▌▐░▌    ▐░▌▐░▌▐░▌    ▐░▌▐░▌       ▐░▌  ##
##  ▐░█▄▄▄▄▄▄▄█░▌     ▐░▌          ▐░▌     ▐░▌          ▐░█▄▄▄▄▄▄▄█░▌▐░▌ ▐░▌   ▐░▌▐░▌ ▐░▌   ▐░▌▐░█▄▄▄▄▄▄▄█░▌  ##
##  ▐░░░░░░░░░░▌      ▐░▌          ▐░▌     ▐░▌          ▐░░░░░░░░░░░▌▐░▌  ▐░▌  ▐░▌▐░▌  ▐░▌  ▐░▌▐░░░░░░░░░░░▌  ##
##  ▐░█▀▀▀▀▀▀▀█░▌     ▐░▌          ▐░▌     ▐░▌          ▐░█▀▀▀▀▀▀▀█░▌▐░▌   ▐░▌ ▐░▌▐░▌   ▐░▌ ▐░▌▐░█▀▀▀▀▀▀▀█░▌  ##
##  ▐░▌       ▐░▌     ▐░▌          ▐░▌     ▐░▌          ▐░▌       ▐░▌▐░▌    ▐░▌▐░▌▐░▌    ▐░▌▐░▌▐░▌       ▐░▌  ##
##  ▐░█▄▄▄▄▄▄▄█░▌ ▄▄▄▄█░█▄▄▄▄      ▐░▌     ▐░█▄▄▄▄▄▄▄▄▄ ▐░▌       ▐░▌▐░▌     ▐░▐░▌▐░▌     ▐░▐░▌▐░▌       ▐░▌  ##
##  ▐░░░░░░░░░░▌ ▐░░░░░░░░░░░▌     ▐░▌     ▐░░░░░░░░░░░▌▐░▌       ▐░▌▐░▌      ▐░░▌▐░▌      ▐░░▌▐░▌       ▐░▌  ##
##   ▀▀▀▀▀▀▀▀▀▀   ▀▀▀▀▀▀▀▀▀▀▀       ▀       ▀▀▀▀▀▀▀▀▀▀▀  ▀         ▀  ▀        ▀▀  ▀        ▀▀  ▀         ▀   ##
################################################################################################################
               ##################################################################################
               ##                                                                              ##
               ##      Project Status: CETI                                                    ##
               ##                                                                              ##
               ##  by DoMato aka hellresistor                                                  ##
               ##  Support donating Bitcanna                                                   ##
               ##  BCNA Address: B9bMDqgoAY7XA5bCwiUazdLKA78h4nGyfL                            ##
               ##                                                                              ##
               ##################################################################################
FOH
sleep 5 && exit
