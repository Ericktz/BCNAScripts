#!/bin/bash
clear
intro(){
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
BCNAHOME=$HOME
BCNACONF=$BCNAHOME/.bitcanna
BCNADIR=$BCNAHOME/Bitcanna
STAKE="100"
sync(){
diff_t=420 ; while [ $diff_t -gt 5 ]
do 
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
##############################################
OFT
 BLKCNT=$(bitcanna-cli getblockcount)
 BLKHSH=$(bitcanna-cli getblockhash $BLKCNT)
 t=$(bitcanna-cli getblock "$BLKHSH" | grep '"time"' | awk -F ":" '{print $2}' | sed -e 's/,$//g')
 cur_t=$(date +%s)
 diff_t=$[$cur_t - $t]
 echo "#############################################"
 echo -n "Syncing... Wait more: "
 echo $diff_t | awk '{printf "%d days, %d:%d:%d\n",$1/(60*60*24),$1/(60*60)%24,$1%(60*60)/60,$1%60}'
 sleep 5
done
}
choice(){
clear
echo "#######################################"
echo "## BitCanna Wallet Installation Menu ##"
"#######################################"
read -n 1 -p "Would you like Configure STAKE (POS) or MasterNode (MN)? (P/M): " choiz;
case $choiz in
    p|P) echo "########################################" && echo "## Selected Stake - POS Configuration ##" && echo "########################################" && sleep 0.5 && stake  ;;
    m|M) echo "############################################" && echo "## Selected MasterNode - MN Configuration ##" && echo "############################################" && sleep 0.5 && masternode ;;
    *) echo "####################" && echo "## Invalid Option ##" && echo "####################" && sleep 0.5 ;;
esac
}
firstrun(){
clear
echo "######################################"
echo "## Lets Initiate configurations ... ##"
echo "######################################" && sleep 0.5
bitcannad -daemon
sleep 10
cat <<EIF
##########################################
## COPY the Returned values (example):  ##
##        rpcuser=xxxxxxxxxx            ##
##        rpcpassword=yyyyyyy           ##
##########################################
##########################################
## PASTE the line of rpcuser=xxxxxxxxxx ##
##########################################
EIF
read RPCUSR
echo "###########################################"
echo "## PASTE the line of rpcpassword=yyyyyyy ##"
echo "###########################################"
read RPCPWD
echo $RPCUSR >> $BCNACONF/bitcanna.conf
echo $RPCPWD >> $BCNACONF/bitcanna.conf
rm $BCNACONF/masternode.conf 
echo "#################################"
echo "## Initial Configurations Done ##" 
echo "#################################"
}
backup(){
clear
echo "###########################"
echo "## Backuping Wallet Info ##"
echo "###########################"
mkdir $BCNAHOME/BACKUP
chmod 700 $BCNAHOME/BACKUP
cat<<EOF 
#########################################################
## To Do This you need set Unlock wallet and NOT stake ##
## 						       ##
##            Write your wallet password               ##
#########################################################
EOF
WLTUNLOCK=$"bitcanna-cli walletpassphrase $WALLETPASS 0 false"
$WLTUNLOCK
BCNADUMP=$(bitcanna-cli dumpprivkey "$WLTADRS")
cat <<EOF > $BCNAHOME/BACKUP/walletinfo.txt
Address: $WLTADRS
Password: $WALLETPASS
Dump: $BCNADUMP
$RPCUSER
$RPCPWD
EOF
BCKWLT=$(bitcanna-cli backupwallet $BCNAHOME/BACKUP/wallet.dat)
$BCKWLT
if [ "$choiz" == "m" ] || [ "$choiz" == "M" ]
 then
  cp $BCNACONF/masternode.conf $BCNAHOME/BACKUP/masternode.conf
fi
echo "#########################" && echo "## Compacting Files .. ##" && echo "#########################"
tar -zcvf $BCNAHOME/WalletBackup.tar.gz $BCNAHOME/BACKUP && chmod 500 $BCNAHOME/WalletBackup.tar.gz
cat<<EOF
#################################################################
## Info Wallet Backuped in: $BCNAHOME/WalletBackup.tar.gz ##
##							       ##
## !!!PLEASE!!! SAVE THIS FILE ON MANY DEVICES ON SECURE       ##
#################################################################
EOF
}
cryptwallet(){
read -s -p "Set PassPhrase to wallet.dat: " WALLETPASS
WLTPSSCMD=$"bitcanna-cli encryptwallet $WALLETPASS"
$WLTPSSCMD
sleep 5
bitcannad -daemon
sleep 15
WLTUNLOCK=$"bitcanna-cli walletpassphrase $WALLETPASS 0 false"
$WLTUNLOCK
if [ "$choiz" == "p" ] || [ "$choiz" == "P" ]
 then
 clear && sleep 1 && echo "############################" && echo "## Set to Staking forever ##" && echo "############################" && sleep 0.5
  WLTUNLOCK=$"bitcanna-cli walletpassphrase $WALLETPASS 0 true"
  $WLTUNLOCK
  echo "##############" && echo "## Unlocked to Stake! ##" && echo "##############" && sleep 3 
  WLTSTAKE=$"bitcanna-cli setstakesplitthreshold $STAKE"
  $WLTSTAKE
  echo "##############" && echo "## Staking with $STAKE ! ##" && echo "##############" && sleep 3
 fi
}
walletposconf(){
echo "staking=1" >> $BCNACONF/bitcanna.conf
clear && echo "####################" && echo "## Connecting ... ##" && echo "####################"
bitcannad -daemon 
sleep 10 && sync && echo "#############################" && echo "## Lets Check again ....!! ##" && echo "#############################" && sleep 5
sync && echo "#########################################################" && echo "## YES!! REALLY! Bitcanna Wallet Fully Syncronized!!! ##" && echo "#########################################################"
clear && echo "###########################" && echo "## My Wallet Address Is: ##" && echo "###########################"
WLTADRS=$(bitcanna-cli getaccountaddress wallet.dat)
echo $WLTADRS && cryptwallet
echo "################################################################################" && echo "## CONGRATULATIONS!! BitCanna POS - Proof-Of-Stake Configurations COMPLETED! ##" && echo "################################################################################" && sleep 3
cat<<EST
####################################################
## TIME TO SEND SOME COINS TO YOUR wallet address ##
##    (check Official Bitcanna.io Claim Guide)    ##
####################################################
## My Wallet Address Is:                          ##
$WLTADRS
####################################################
EST
read -n 1 -s -r -p "Press any key to Continue this Script"
}
walletmnconf(){
echo "staking=0" >> $BCNAHOME/.bitcanna/bitcanna.conf
echo "#########################################################################################"
read -p "## Set ID of this Masternode. Default: 0 (Zer0 - To First Node, 1 - To 2nd node, .....): " IDMN
echo "#########################################################################################"
read -p "## Set Your MasterNode wallet Alias (usually: MN0): " MNALIAS
echo "#########################################################################################"
clear && echo "####################" && echo "## Connecting ... ##" && echo "####################"
bitcannad -daemon 
sleep 10 && sync && echo "#############################" && echo "## Lets Check again ....!! ##" && echo "#############################" && sleep 5
sync && echo "#########################################################" && echo "## YES!! REALLY! Bitcanna Wallet Fully Syncronized!!! ##" && echo "#########################################################"
echo "##########################################" && echo "## Generate your MasterNode Private Key ##" && echo "##########################################"
MNGENK=$(bitcanna-cli masternode genkey)
echo $MNGENK
echo "####################################################" && echo "## Creating NEW Address to MASTERNODE -> $MNALIAS ##" && echo "####################################################"
NEWWLTADRS=$(bitcanna-cli getnewaddress $MNALIAS)
echo $NEWWLTADRS
WLTADRS=$(bitcanna-cli getaccountaddress wallet.dat)
cat<<EST
######################################################################
## TIME TO SEND YOUR 100K COINS TO YOUR "$MNALIAS" wallet address ##
##            (check Official Bitcanna.io Claim Guide)              ##
######################################################################
## My $MNALIAS Wallet Address Is:                                   ##
$WLTADRS
######################################################################
EST
read -n 1 -s -r -p "`echo -e '##########################################################\n## Please wait at least 16+ confirmations of trasaction ##\n##########################################################\n '`"
read -n 1 -s -r -p "`echo -e '########################################################\n## After 16+ confirmations, Press any key to continue ##\n########################################################\n '`" 
read -n 1 -s -r -p "`echo -e '###############################################\n## Sure? 16 Conf.? Press any key to continue ##\n############################################### \n'`"
clear
echo "#############################################" && echo "## IDENTIFY YOUR TRANSACTION ID - TxID !!! ##" && echo "#############################################"
bitcanna-cli listtransactions
read -p "`echo -e '\n##############################\n## Copy IDENTIFIED TxId !!! ##\n##############################\n: '`" TXID
sleep 0.5 && clear && echo "##################################################" && echo "## Lets Find the collateral Output TX and INDEX ##" && echo "##################################################"
bitcanna-cli masternode outputs
echo "######################################" && echo "## Copy/Paste the Requested Info!!! ##" && echo "######################################"
read -p "`echo -e '\n###################################\n## Set the Long part (Tx) string ##\n###################################\n: '`" MNTX
read -p "`echo -e '\n####################################\n## Set the Short part (Id) string ##\n####################################\n: '`" MNID
pkill bitcannad
sleep 10
echo "#####################################" && echo "## Getting Your Public/External IP ##" && echo "#####################################"
VPSIP="$(ip route get 8.8.8.8 | awk -F"src " 'NR==1{split($2,a," ");print a[1]}')"
echo "externalip=$VPSIP" >> $BCNACONF/bitcanna.conf && echo "port=12888" >> $BCNACONF/bitcanna.conf
echo "$IDMN $MNALIAS $VPSIP:12888 $MNGENK $MNTX $MNID" > $BCNACONF/masternode.conf && cat $BCNACONF/masternode.conf
read -n 1 -s -r -p "`echo -e '\n#############################################################\n## Are you Verified The Results? Press any key to continue ##\n#############################################################\n '`" 
echo "#########################" && echo "## Run Bitcanna Wallet ##" && echo "#########################"
bitcannad --maxconnections=1000 -daemon
sleep 10 && echo "###############################" && echo "## Activating MasterNode ... ##" && echo "###############################"
bitcanna-cli masternode start-many
sleep 2 
cat<<ETF
########################################################
## No Reference on Guides about Encrypt on MasterNode ##
##              Maybe cause problems?                 ##
##               PROTECT YOUR Server                  ##
########################################################
ETF
read -p "You want Encrypt MasterNode Wallet? (y/n)" CRYPSN
if [ "$CRYPSN" == "y" ]
then
cryptwallet
fi
}
mess(){
clear && echo "#########################" && echo "## Cleaning the things ##" && echo "#########################"
rm $BCNADIR/bcna_unix_29_07_19
rm -R -f $BCNAHOME/BACKUP
rm $BCNAHOME/.bash_history
echo "##############################" && echo "## Cleaned garbage and tracks ##" && echo "##############################" && sleep 1
}
masternode(){
firstrun
walletmnconf
backup
}
stake(){
firstrun
walletposconf
backup
}
final(){
clear
bitcanna-cli stop
sleep 5
if [ "$choiz" == "p" ] || [ "$choiz" == "P" ]
then
bitcannad -daemon
sleep 10
bitcanna-cli walletpassphrase $WALLETPASS 0 true 
sleep 3 && clear
bitcanna-cli getstakingstatus
cat<<EOF
#############################################################
## Proof Of Stake Finished and Running!! Now Can LogOut! ####
#############################################################
EOF
sleep 5
else
bitcannad --maxconnections=1000 -daemon
sleep 10
bitcanna-cli masternode start-many
sleep 2
cat<<EOF
#######################################################
## MasterNode Finished and Running!! Now Can LogOut! ##
#######################################################
EOF
sleep 5
fi
}
choice
mess
final
clear
cat<<FOH

 ▄▄▄▄▄▄▄▄▄▄   ▄▄▄▄▄▄▄▄▄▄▄   ▄▄▄▄▄▄▄▄▄▄▄   ▄▄▄▄▄▄▄▄▄▄▄  ▄▄▄▄▄▄▄▄▄▄▄   ▄▄        ▄   ▄▄        ▄  ▄▄▄▄▄▄▄▄▄▄▄  
▐░░░░░░░░░░▌ ▐░░░░░░░░░░░▌ ▐░░░░░░░░░░░▌ ▐░░░░░░░░░░░▌▐░░░░░░░░░░░▌ ▐░░▌      ▐░▌ ▐░░▌      ▐░▌▐░░░░░░░░░░░▌ 
▐░█▀▀▀▀▀▀▀█░▌ ▀▀▀▀█░█▀▀▀▀   ▀▀▀▀█░█▀▀▀▀  ▐░█▀▀▀▀▀▀▀▀▀ ▐░█▀▀▀▀▀▀▀█░▌ ▐░▌░▌     ▐░▌ ▐░▌░▌     ▐░▌▐░█▀▀▀▀▀▀▀█░▌ 
▐░▌       ▐░▌     ▐░▌           ▐░▌      ▐░▌          ▐░▌       ▐░▌ ▐░▌▐░▌    ▐░▌ ▐░▌▐░▌    ▐░▌▐░▌       ▐░▌ 
▐░█▄▄▄▄▄▄▄█░▌     ▐░▌           ▐░▌      ▐░▌          ▐░█▄▄▄▄▄▄▄█░▌ ▐░▌ ▐░▌   ▐░▌ ▐░▌ ▐░▌   ▐░▌▐░█▄▄▄▄▄▄▄█░▌ 
▐░░░░░░░░░░▌      ▐░▌           ▐░▌      ▐░▌          ▐░░░░░░░░░░░▌ ▐░▌  ▐░▌  ▐░▌ ▐░▌  ▐░▌  ▐░▌▐░░░░░░░░░░░▌ 
▐░█▀▀▀▀▀▀▀█░▌     ▐░▌           ▐░▌      ▐░▌          ▐░█▀▀▀▀▀▀▀█░▌ ▐░▌   ▐░▌ ▐░▌ ▐░▌   ▐░▌ ▐░▌▐░█▀▀▀▀▀▀▀█░▌ 
▐░▌       ▐░▌     ▐░▌           ▐░▌      ▐░▌          ▐░▌       ▐░▌ ▐░▌    ▐░▌▐░▌ ▐░▌    ▐░▌▐░▌▐░▌       ▐░▌ 
▐░█▄▄▄▄▄▄▄█░▌ ▄▄▄▄█░█▄▄▄▄       ▐░▌      ▐░█▄▄▄▄▄▄▄▄▄ ▐░▌       ▐░▌ ▐░▌     ▐░▐░▌ ▐░▌     ▐░▐░▌▐░▌       ▐░▌ 
▐░░░░░░░░░░▌ ▐░░░░░░░░░░░▌      ▐░▌      ▐░░░░░░░░░░░▌▐░▌       ▐░▌ ▐░▌      ▐░░▌ ▐░▌      ▐░░▌▐░▌       ▐░▌ 
 ▀▀▀▀▀▀▀▀▀▀   ▀▀▀▀▀▀▀▀▀▀▀        ▀        ▀▀▀▀▀▀▀▀▀▀▀  ▀         ▀   ▀        ▀▀   ▀        ▀▀  ▀         ▀  


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
