#!/bin/bash
### Bitcanna Team!!
# Compile next Version of wallet directly into .ZIP no into folder with that name (or put the name same as package :p
### Pleaaasseee :P
####################################
EXTRACTEDPKG="bcna_unix_29_07_19"
####################################
varys(){
STAKE="100"    ### Can ChangeIt!! Sure yourself You Know What Are You Doing!! ###
BCNAREP="https://github.com/BitCannaGlobal/BCNA/releases/download"
GETLAST=$(curl --silent "https://api.github.com/repos/BitCannaGlobal/BCNA/releases/latest" | grep -Po '"tag_name": "\K.*?(?=")')
BCNAPKG="bcna-$GETLAST-unix.zip"
BCNAHOME="/home/$BCNAUSER"
BCNACONF="$BCNAHOME/.bitcanna"
BCNADIR="$BCNAHOME/Bitcanna"
BCNASCRIPTS="$BCNAHOME/scripts"
BCNAPORT="12888"
BCNACLI=bitcanna-cli
BCNAD=bitcannad
}

intro(){
cat<< EOF
##################################################################################
##  bbc                              Script Contribution to BitCanna Community  ##
##  bbb                                     to Ubuntu 18.04 LTS Server          ##
##  bbbbb                            #############################################
##  bbbbb                               Executing this script you can Install   ##
##  bbbbb   cbcb          bbbbbb         Configure your Bitcanna Wallet to:     ##
##  bbbbb bbbbbbbbb     bbbbbbbbbb                                              ##
##  bbbcb bbbbbbbbbb   cbbbbbbcbbbb           - Stake (Proof-Of-Stake)          ##
##  bbbbbbbb    bbbbbibbbb      cbbb          - MN    (Master-Node)             ##
##  bbbbib        bbb bibbb                                                     ##
##  bbbbib         bbbbbb             ############################################
##  bbbbbb         bbbbbb                                                       ##
##  bbcbbb         bbbbcb                      Project Ver: V1.9.8.27           ##
##  bbbbbb         bbbbbcb                                                      ##
##  bbbbbbbb      bbbbbbbbbc     cbbb       by DoMato aka hellresistor          ##
##    bbbbbbbbbbbbbcbb bbbbbbbbbbbbb        Support donating Bitcanna           ##
##     bbbbbbbbbbb bbb cbbbbbbbbbib                                             ##
##       bbbbbbbbb       bbbbibbbb    BCNA: B9bMDqgoAY7XA5bCwiUazdLKA78h4nGyfL  ##
##                                                                              ##
################################################################################## 
##################################################################################
##                                                                              ##
##  HAVE IN MIND!! EVERY TIME DO YOUR OWN BACKUPS BEFORE USING THIS SCRIPT      ##
##            I have NO responsability about system corruption!                 ##
##                     Use this Script at your own risk!                        ##
##                   (leave feedback, issues, suggestions)                      ##
##################################################################################

Continue this Script are Accepting you are the only responsible
EOF
echo && read -n 1 -s -r -p "Press any key to continue this Script..."
sleep 0.5 && echo && echo
}
choi(){
while true
do
clear
echo "$USER"
## Temporary Solved Issue to end with old user script
## execution. And after sudo execution script will verified kill usradm script
if [ "$(whoami)" != "root" ]
 then 
 exit 0
fi
cat<<EOF
#######################################
## BitCanna Wallet Installation Menu ##
#######################################
## Would you like Install/Configure) ##
##   P --> Full Node (P.O.Stake)     ##
##   M --> MasterNode (MN)?          ##
#######################################
EOF
read -p "(P/M): " choiz;
case $choiz in
    p|P) break ;;
    m|M) break ;;
    *) echo "########################
## Really??? Missed!? ##
########################"
       sleep 3 ;;
esac
done
}

check(){
echo "###########################################
## Checking If script is running as root ##
###########################################"
sleep 1
if [ "$(whoami)" != "root" ]
 then 
 echo "###################
## Login as root ##
###################"
 sleep 2
 clear
 sudo su -c "$0" root
 else
  clear
  echo "##################################
## You are Root! Will Continue! ##
##################################"
sleep 2
fi
}

getinfo(){
echo && echo
echo "#######################################
## Some questions to do before start ##
#######################################"

read -p"`echo -e '#############################################
## What is New User to BCNA Wallet?:  '`" BCNAUSER 
varys

echo "#####################################
## Getting Public/External IP SRV ##
#####################################"

VPSIP="$(ip route get 8.8.8.8 | awk -F"src " 'NR==1{split($2,a," ");print a[1]}')"

echo "############################
## IP Its: $VPSIP ##
############################"
sleep 2
}

userad(){
clear
echo "##################################################
## Creating user to bitcanna and add to sudoers ##
##################################################"

adduser $BCNAUSER --shell=/bin/bash
usermod -aG sudo $BCNAUSER

sed -i "/root/a$BCNAUSER\tALL=(ALL:ALL) ALL" /etc/sudoers

echo "##################################################
## User $BCNAUSER Created and Permissions Added ##
##################################################"
sleep 2
}

bcnadown(){
clear
echo "###############################################################
## Lets Download and Extract the Bitcanna Wallet from GitHub ##
###############################################################"

sleep 2
wget -P $BCNAHOME $BCNAREP/$GETLAST/$BCNAPKG
mkdir $BCNADIR && unzip $BCNAHOME/$BCNAPKG -d $BCNAHOME
cp $BCNAHOME/$EXTRACTEDPKG/* $BCNADIR && chmod -R 770 $BCNADIR
chown -R $BCNAUSER $BCNADIR
cp $BCNAHOME/$EXTRACTEDPKG/* /usr/local/bin
chmod +x /usr/local/bin/bitcanna*
## Create scripts folder ##
mkdir $BCNASCRIPTS
chmod 770 $BCNASCRIPTS
chown -R $BCNAUSER $BCNASCRIPTS

echo "###########################################
## Downloaded and Extracted to: $BCNADIR ##
###########################################"
sleep 3
}

service(){
clear
echo "###############################
## Creating bitcanna Service ##
###############################"

sleep 0.5
cat <<EOF> /tmp/bitcannad.service
[Unit]
Description=BCNAs distributed currency daemon EDITED by hellresistor
After=network.target
[Service]
User=$BCNAUSER
Group=$BCNAUSER
Type=forking
PIDFile=$BCNACONF/bitcannad.pid
EOF
if [ "$choiz" == "m" ] || [ "$choiz" == "M" ]
 then
  echo "ExecStart=$BCNADIR/bitcannad --maxconnections=1000 -daemon -pid=$BCNACONF/bitcannad.pid -conf=$BCNACONF/bitcanna.conf -datadir=$BCNACONF" >> /tmp/bitcannad.service
  echo "ExecStartPost=$BCNADIR/bitcanna-cli masternode start-many" >> /tmp/bitcannad.service
 else
  echo "ExecStart=$BCNADIR/bitcannad -daemon -pid=$BCNACONF/bitcannad.pid -conf=$BCNACONF/bitcanna.conf -datadir=$BCNACONF" >> /tmp/bitcannad.service
fi
cat <<EOF>> /tmp/bitcannad.service
ExecStop=$BCNADIR/bitcanna-cli stop
Restart=on-failure
PrivateTmp=true
TimeoutStopSec=60s
TimeoutStartSec=2s
StartLimitInterval=120
StartLimitBurst=5
StartLimitAction=reboot
ProtectSystem=full
NoNewPrivileges=true
PrivateDevices=true
MemoryDenyWriteExecute=true

[Install]
WantedBy=multi-user.target
EOF

cp /tmp/bitcannad.service /lib/systemd/system/bitcannad.service

systemctl enable bitcannad.service
systemctl daemon-reload

echo "##########################################
## BitCanna Service (bitcannad.service) ##
##########################################"
sleep 3
}
bypass(){
clear
echo "###################################################
## Preparing Script to Continue with user: $BCNAUSER ##
###################################################"
sleep 0.5

cat<<FOP > $BCNAHOME/BCNA-Installer2.sh
#!/bin/bash
clear
intro(){
cat<< EOF
################################################################
##         Script Contribution to BitCanna Community          ##
##                 To Ubuntu 18.04 LTS Server                 ##
################################################################
##                                                            ##
##                Logged As $BCNAUSER Session                 ##
##                                                            ##
################################################################
EOF
echo "Continuing with Configuration..."
read -n 1 -s -r -p "Press any key to Executing this Script" 
}

choice(){
clear
if [ "$choiz" == "m" ] || [ "$choiz" == "M" ]
then 
 echo "######################################################
## Have been Selected MasterNode - MN Configuration ##
######################################################"
sleep 2
masternode
else
 echo "#####################################################
## Have been Selected FullNode - POS Configuration ##
#####################################################"
 sleep 2
 stake
fi
}

sync(){
diff_t=420 ; while [ \$diff_t -gt 5 ]
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

 BLKCNT=\$(bitcanna-cli getblockcount)
 BLKHSH=\$(bitcanna-cli getblockhash \$BLKCNT)
 t=\$(bitcanna-cli getblock "\$BLKHSH" | grep '"time"' | awk -F ":" '{print \$2}' | sed -e 's/,\$//g')
 cur_t=\$(date +%s)
 diff_t=\$[\$cur_t - \$t]
 
 echo -n "#############################################
Syncing... Wait more: "

 echo \$diff_t | awk '{printf "%d days, %d:%d:%d\n",\$1/(60*60*24),\$1/(60*60)%24,\$1%(60*60)/60,\$1%60}'
 
 sleep 5
done
}

firstrun(){
clear
echo "######################################
## Lets Initiate configurations ... ##
######################################"

sleep 0.5
bitcannad -daemon
sleep 10

cat <<EOF
############################################
##   COPY the Returned values (example):  ##
##          rpcuser = xxxxxxxxxx          ##
##          rpcpassword = yyyyyyy         ##
############################################
############################################
## PASTE the line of rpcuser = xxxxxxxxxx ##
############################################
EOF

read RPCUSR

echo "###########################################
## PASTE the line of rpcpassword=yyyyyyy ##
###########################################"

read RPCPWD
echo \$RPCUSR >> $BCNACONF/bitcanna.conf
echo \$RPCPWD >> $BCNACONF/bitcanna.conf
rm $BCNACONF/masternode.conf

echo "#################################
## Initial Configurations Done ##
#################################"
}

backup(){
clear
echo "###########################
## Backuping Wallet Info ## 
###########################"

mkdir $BCNAHOME/BACKUP
chmod 700 $BCNAHOME/BACKUP

cat<<EOF 
#########################################################
## To Do This you need set Unlock wallet and NOT stake ##
##                                                     ##
##            Write your wallet password               ##
#########################################################
EOF

WLTUNLOCK=\$"bitcanna-cli walletpassphrase \$WALLETPASS 0 false"
\$WLTUNLOCK
BCNADUMP=\$(bitcanna-cli dumpprivkey "\$WLTADRS")

cat <<EOF > $BCNAHOME/BACKUP/walletinfo.txt
Server Info:
Host: \$HOSTNAME
IP: \$VPSIP
Wallet Info:
Address: \$WLTADRS
Password: \$WALLETPASS
Dump: \$BCNADUMP
\$RPCUSR
\$RPCPWD
EOF

BCKWLT=\$(bitcanna-cli backupwallet $BCNAHOME/BACKUP/wallet.dat)
\$BCKWLT
if [ "$choiz" == "m" ] || [ "$choiz" == "M" ]
 then
  cp $BCNACONF/masternode.conf $BCNAHOME/BACKUP/masternode.conf
fi

echo "#########################
## Compacting Files .. ##
#########################"

## Compressed and Permissions set ##
tar -zcvf $BCNAHOME/WalletBackup.tar.gz $BCNAHOME/BACKUP
chmod 500 $BCNAHOME/WalletBackup.tar.gz

cat<<EOF
#################################################################
## Info Wallet Backuped in: $BCNAHOME/WalletBackup.tar.gz 
##                        !!!PLEASE!!                          ##
##        SAVE THIS FILE ON MANY DEVICES ON SECURE             ##
#################################################################
EOF

sleep 7
}

cryptwallet(){
read -s -p "Set PassPhrase to wallet.dat: " WALLETPASS
echo
echo "################################
##Please Wait a little bit... ##
################################"

WLTPSSCMD=\$"bitcanna-cli encryptwallet \$WALLETPASS"
\$WLTPSSCMD
sleep 15

echo "######################################################
## Restarting BitCanna Wallet with Wallet Encrypted ##
######################################################"

bitcannad -daemon
sleep 15
WLTUNLOCK=\$"bitcanna-cli walletpassphrase \$WALLETPASS 0 false"
\$WLTUNLOCK

if [ "$choiz" == "p" ] || [ "$choiz" == "P" ]
 then
 clear
 echo "############################"
 echo "## Set to Staking forever ##"
 echo "############################"
 
 sleep 0.5
  WLTUNLOCK=\$"bitcanna-cli walletpassphrase \$WALLETPASS 0 true"
  \$WLTUNLOCK
  sleep 2
  echo "########################
## Unlocked to Stake! ##
########################"
  sleep 2 
  WLTSTAKE=\$"bitcanna-cli setstakesplitthreshold $STAKE"
  \$WLTSTAKE
  sleep 2
  
  echo "###########################
## Staking with $STAKE ! ##
###########################"
  sleep 2
 fi
}

walletposconf(){
echo "staking=1" >> $BCNACONF/bitcanna.conf
clear
echo "####################
## Connecting ... ##
####################"

bitcannad -daemon 
sleep 10
sync
echo "#############################"
echo "## Lets Check again ....!! ##"
echo "#############################"

sleep 15
sync
echo "#########################################################
## YES!! REALLY! Bitcanna Wallet Fully Syncronized!!!  ##
#########################################################"

clear
echo "###########################
## My Wallet Address Is: ##"
WLTADRS=\$(bitcanna-cli getaccountaddress wallet.dat)
echo \$WLTADRS && cryptwallet

echo "################################################################################
## CONGRATULATIONS!! BitCanna POS - Proof-Of-Stake Configurations COMPLETED!  ##
################################################################################"
sleep 3

cat<<EOF
####################################################
## TIME TO SEND SOME COINS TO YOUR wallet address ##
##    (check Official Bitcanna.io Claim Guide)    ##
####################################################
## My Wallet Address Is:                          ##
\$WLTADRS
####################################################
EOF

read -n 1 -s -r -p "Press any key to Continue..."
}

walletmnconf(){
echo "staking=0" >> $BCNACONF/bitcanna.conf

echo "#########################################################################################"
read -p "## Set ID of this Masternode. Default: 0 (Zer0 - To First Node, 1 - To 2nd node, .....): " IDMN
echo "#########################################################################################"
read -p "## Set Your MasterNode wallet Alias (usually: MN0): " MNALIAS
echo "#########################################################################################"
clear

echo "####################
## Connecting ... ##
####################"

bitcannad -daemon 
sleep 10
sync

echo "#############################
## Lets Check again ....!! ##
#############################"

sleep 5
sync

echo "#########################################################
## YES!! REALLY! Bitcanna Wallet Fully Syncronized!!!  ##
#########################################################"

sleep 2
echo "##########################################
## Generate your MasterNode Private Key ##
##########################################"

MNGENK=\$(bitcanna-cli masternode genkey)
echo \$MNGENK
echo "####################################################
## Creating NEW Address to MASTERNODE -> \$MNALIAS 
####################################################"

NEWWLTADRS=\$(bitcanna-cli getnewaddress \$MNALIAS)
echo \$NEWWLTADRS
WLTADRS=\$(bitcanna-cli getaccountaddress wallet.dat)

cat<<EOF
######################################################################
## TIME TO SEND YOUR 100K COINS TO YOUR "\$MNALIAS" wallet address ##
##            (check Official Bitcanna.io Claim Guide)              ##
######################################################################
## My $MNALIAS Wallet Address Is:                                   ##
\$WLTADRS
######################################################################
EOF

read -n 1 -s -r -p "`echo -e '##########################################################\n## Please wait at least 16+ confirmations of trasaction ##\n##########################################################\n '`"
read -n 1 -s -r -p "`echo -e '########################################################\n## After 16+ confirmations, Press any key to continue ##\n########################################################\n '`" 
read -n 1 -s -r -p "`echo -e '###############################################\n## Sure? 16 Conf.? Press any key to continue ##\n############################################### \n'`"
read -n 1 -s -r -p "`echo -e '###############################################\n## OK! OK! Anoying Right? Only SURE as OK!!! ##\n############################################### \n'`"
clear

echo "#############################################
## IDENTIFY YOUR TRANSACTION ID - TxID !!! ##
#############################################"

bitcanna-cli listtransactions
read -p "`echo -e '\n##############################\n## Copy IDENTIFIED TxId !!! ##\n##############################\n: '`" TXID
sleep 0.5
clear
echo "##################################################
## Lets Find the collateral Output TX and INDEX ##
##################################################"

bitcanna-cli masternode outputs

echo "######################################
## Copy/Paste the Requested Info!!! ##
######################################"

read -p "`echo -e '\n###################################\n## Set the Long part (Tx) string ##\n###################################\n: '`" MNTX
read -p "`echo -e '\n####################################\n## Set the Short part (Id) string ##\n####################################\n: '`" MNID

pkill bitcannad

sleep 10

echo "externalip=$VPSIP" >> $BCNACONF/bitcanna.conf && echo "port=$BCNAPORT" >> $BCNACONF/bitcanna.conf
echo "\$IDMN \$MNALIAS $VPSIP:$BCNAPORT \$MNGENK \$MNTX \$MNID" > $BCNACONF/masternode.conf && cat $BCNACONF/masternode.conf

read -n 1 -s -r -p "`echo -e '\n#############################################################\n## Are you Verified The Results? Press any key to continue ##\n#############################################################\n '`" 

echo "#########################
## Run Bitcanna Wallet ##
#########################"

bitcannad --maxconnections=1000 -daemon
sleep 10

echo "###############################
## Activating MasterNode ... ##
###############################"

bitcanna-cli masternode start-many
sleep 2 

cat<<EOF
########################################################
## No Reference on Guides about Encrypt on MasterNode ##
##              Maybe cause problems?                 ##
##      PROTECT YOUR Server (see ReadMe file)         ##
########################################################
EOF

read -p "You want Encrypt MasterNode Wallet? (y/n)" CRYPSN

if [ "\$CRYPSN" == "y" ]
then
cryptwallet
fi
}

mess(){
clear
echo "#########################
## Cleaning the things ##
#########################"

rm -R -f $BCNAHOME/BACKUP
sed -i "/BCNA-Installer2.sh/d" $BCNAHOME/.bashrc

echo "#####################
## Cleaned garbage ##
#####################"
sleep 1
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
echo "$BCNASCRIPTS/BCNA-TERMINAL.sh" >> $BCNAHOME/.bashrc
clear
bitcanna-cli stop
sleep 5
if [ "$choiz" == "p" ] || [ "$choiz" == "P" ]
then
bitcannad -daemon
sleep 10

bitcanna-cli walletpassphrase \$WALLETPASS 0 true 
sleep 3 && clear

bitcanna-cli getstakingstatus

cat<<EOF
#############################################################
## Proof Of Stake Finished and Running!! Now Can LogOut! ####
#############################################################
EOF

else
bitcannad --maxconnections=1000 -daemon
sleep 10

bitcanna-cli walletpassphrase \$WALLETPASS 0 false
sleep 10

bitcanna-cli masternode start-many
sleep 2

cat<<EOF
#########################################################
## MasterNode Finished and Running!! Now Can LogOut... ##
#########################################################
EOF

fi
sleep 5
}

choice
mess
final
clear

cat<<EOF

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
             ##                         Project Ver: V1.9.8.27                               ##
             ##                                                                              ##
             ##  by DoMato aka hellresistor                                                  ##
             ##                       Support donating Bitcanna                              ##
             ##  BCNA Address: B9bMDqgoAY7XA5bCwiUazdLKA78h4nGyfL                            ##
             ##                                                                              ##
             ##################################################################################
EOF
sleep 2

FOP
sleep 3

chmod 700 $BCNAHOME/BCNA-Installer2.sh && chown $BCNAUSER $BCNAHOME/BCNA-Installer2.sh
echo "$BCNAHOME/BCNA-Installer2.sh" >> $BCNAHOME/.bashrc

bcnaterm

cat<<ETF
###################################################
## System ready for BitCanna Wallet installation ##
###################################################
##      !!!! Dont Forget To Continue !!!!        ##
##       Next Login, With User: $BCNAUSER         ##
###################################################
ETF

read -n 1 -s -r -p "Press any key to REBOOT" && echo "Rebooting..." && sleep 2 && mess && reboot
}

mess(){
clear
echo "#########################
## Cleaning the things ##
#########################"

apt clean
rm /tmp/bitcannad.service
rm $BCNAHOME/$BCNAPKG
rm -r $BCNAHOME/$EXTRACTEDPKG
echo " " > $HOME/.bash_history

echo "######################################"
echo "## Cleaned garbage packages temp... ##"
echo "######################################"
sleep 2
}

bcnaterm(){
clear

cat<<EOF
####################################################
## Surprise!!! Preparing a Console To wallet user ##
####################################################
EOF

sleep 0.5 && echo

cat<<EOF> $BCNASCRIPTS/BCNA-TERMINAL.sh
#!/bin/bash
#Peers: $BCNACLI getpeerinfo | Connections: $BCNACLI getconnectioncount | Block: $BCNACLI getblockcount | Ping: $BCNACLI ping
while :
do
clear
cat<<ETF
############################################################
##                                                        ##
##                     Bitcanna Console                   ##
##                                       by: hellresistor ##
############################################################
##____________________ Wallet Manager ____________________##
EOF
if [ "$choiz" == "p" ] || [ "$choiz" == "P" ];
then
echo "## U- Unlock to STAKE      ##  W- Get Wallet Address      ##" >> $BCNASCRIPTS/BCNA-TERMINAL.sh
else
echo "## U- Unlock to MasterNode ##  W- Get Wallet Address      ##" >> $BCNASCRIPTS/BCNA-TERMINAL.sh
fi
cat<<EOF>> $BCNASCRIPTS/BCNA-TERMINAL.sh
##                         ##  I- Get List Address        ##
## L- Lock Wallet          ##  B- Get Balance             ##
##                         ##                             ##
EOF
if [ "$choiz" == "p" ] || [ "$choiz" == "P" ];
then
cat<<EOF>>$BCNASCRIPTS/BCNA-TERMINAL.sh
## I- Get Blockchain Info  ##  D- Set Stake Threshold     ##
## N- Get Network Info	   ##  K- Get StakeSplito Info    ##
##                         ##                             ##
##                         ##                             ##
EOF
else
cat<<EOF>>$BCNASCRIPTS/BCNA-TERMINAL.sh
## I- Get Blockchain Info  ##                             ##
## N- Get Network Info	   ##                             ##
##                         ##                             ##
##                         ##                             ##
EOF
fi
cat<<EOF>>$BCNASCRIPTS/BCNA-TERMINAL.sh
############################################################
##__________________ Bitcanna Manager ____________________##
##    P- StoP Bitcanna            T- StarT Bitcanna       ##
############################################################
##___________________ S Y S T E M ________________________##
##  S/H- Shell                        H- Halt/Shutdown    ##
##      (help)         R- Reboot                          ##
############################################################
ETF
EOF
cat<<EOF>>$BCNASCRIPTS/BCNA-TERMINAL.sh
read -p "Choice:" SEL
case "\$SEL" in
  u|U) read -n "Put Wallet Password/Passphrase?" MWLTPASS
EOF
if [ "$choiz" == "m" ] || [ "$choiz" == "M" ];
then

cat<<EOF>>$BCNASCRIPTS/BCNA-TERMINAL.sh
$BCNACLI walletpassphrase \$MWLTPASS 0 false
$BCNACLI masternode start-many
read -p "Press [Enter] key to MENU..." readEnterKey ;;
EOF

else

cat<<EOF>>$BCNASCRIPTS/BCNA-TERMINAL.sh
$BCNACLI walletpassphrase \$MWLTPASS 0 true
read -p "Press [Enter] key to MENU..." readEnterKey ;;
EOF

fi

cat<<EOF>>$BCNASCRIPTS/BCNA-TERMINAL.sh
  l|L) $BCNACLI wallet-lock 
  read -p "Press [Enter] key to MENU..." readEnterKey;;
  w|W) $BCNACLI getaccountaddress wallet.dat
  read -p "Press [Enter] key to MENU..." readEnterKey ;;
  i|I) $BCNACLI getblockchaininfo
  read -p "Press [Enter] key to MENU..." readEnterKey ;;
  b|B) $BCNACLI getbalance wallet.dat
  read -p "Press [Enter] key to MENU..." readEnterKey ;;
  i|I) $BCNACLI getinfo
  read -p "Press [Enter] key to MENU..." readEnterKey ;;
  n|N) $BCNACLI getnetworkinfo
  read -p "Press [Enter] key to MENU..." readEnterKey ;;
EOF

if [ "$choiz" == "p" ] || [ "$choiz" == "P" ];
then

cat<<EOF>>$BCNASCRIPTS/BCNA-TERMINAL.sh
  k|K) $BCNACLI getstakesplitthreshold
  read -p "Press [Enter] key to MENU..." readEnterKey ;;
  d|D) read -n "Set how much your Stake Split (1-999,999):" SETSTAKE
     $BCNACLI setstakesplitthreshold \$SETSTAKE
     read -p "Press [Enter] key to MENU..." readEnterKey ;;
EOF

fi

echo "  p|P) $BCNACLI stop" >> $BCNASCRIPTS/BCNA-TERMINAL.sh
echo "       sleep 3 ;;" >> $BCNASCRIPTS/BCNA-TERMINAL.sh

if [ "$choiz" == "p" ] || [ "$choiz" == "P" ];
then

cat<<EOF>>$BCNASCRIPTS/BCNA-TERMINAL.sh
  t|T) echo "Starting Bitcanna Server"
       $BCNAD -daemon
       sleep 15 ;;
EOF

else

cat<<EOF>>$BCNASCRIPTS/BCNA-TERMINAL.sh
  t|T) echo "Starting Bitcanna MasterNode"
       $BCNAD --maxconnections=1000 -daemon
       sleep 15 ;;
EOF

fi

cat<<EOF>>$BCNASCRIPTS/BCNA-TERMINAL.sh
  s|S) clear
       $BCNACLI help
       break;;
  r|R) sudo reboot ;;
  h|H) sudo shutdown -s halt ;;
  *) echo -n "Seriously!?!? Missed??!? Next Try, do it with more CBD/THC..."
     sleep 3;;
  esac
done
EOF

sleep 4
chmod 700 $BCNASCRIPTS/BCNA-TERMINAL.sh && chown $BCNAUSER $BCNASCRIPTS/BCNA-TERMINAL.sh

echo "#####################################################
## Terminal to user $BCNAUSER are Configurated Enjoy!
#####################################################"
sleep 3
}

fwll(){
clear
echo "####################################################
## Adding rule to UFW Firewall port: $BCNAPORT 
####################################################"

sleep 1
ufw allow $BCNAPORT
ufw enable

echo "########################################################
##  PLEASE ITS APLLIED SOME RULES! PLEASE CHECK ALL!  ##
##  PLEASE!! If you find security issue, CONTACT ASAP ##
########################################################"
sleep 3
}

f2b(){
clear
echo "##########################################
## Adding Fail2Ban Security to Bitcanna ##
##########################################"

## Adding Cryptowallet to f2b
if [ -f /etc/fail2ban/filter.d/bitcanna.conf ]; then

cat >/etc/fail2ban/filter.d/bitcanna.conf <<EOF
# Fail2Ban configuration file for bitcanna
[bitcanna]
enabled = true
port    = $BCNAPORT
filter  = bitcanna
logpath = $BCNACONF/debug.log
maxretry = 0
bantime  = 1w
findtime = 1d
[Definition]
failregex = .*receive version message: Why\? Because fack u.*peeraddr=<HOST>:.*
ignoreregex =
EOF

fi

if [ -f /etc/fail2ban/filter.d/bitcanna_banned.conf ]; then

cat >/etc/fail2ban/filter.d/bitcanna_banned.conf <<EOF
[bitcannad_banned]
enabled = true
port    = $BCNAPORT
filter = bitcannad_banned
logpath = $BCNACONF/debug.log
maxretry = 0
bantime  = 1w
findtime = 1d
[Definition]
failregex = .*connection from <HOST>:.* dropped
ignoreregex =
EOF

fi

systemctl restart fail2ban
fail2ban-client reload
fail2ban-client add bitcanna
fail2ban-client add bitcannad_banned

echo "###########################################
## Fail 2 Ban Configured to $CRYPTOCOIN
###########################################"
sleep 3
}

intro
check
choi
getinfo
userad
bcnadown
service
fwll
f2b
bypass
