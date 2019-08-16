#!/bin/bash
### Bitcanna Team!!
# Compile next Version of wallet directly into .ZIP no into folder with that name (or put the name same as package :p
### Pleaaasseee :P
####################################
EXTRACTEDPKG=bcna_unix_29_07_19
####################################
varys(){
STAKE="100"    ### Can ChangeIt!! Sure yourself You Know What Are You Doing!! ###
BCNAREP="https://github.com/BitCannaGlobal/BCNA/releases/download"
GETLAST=$(curl --silent "https://api.github.com/repos/BitCannaGlobal/BCNA/releases/latest" | grep -Po '"tag_name": "\K.*?(?=")')
BCNAPKG="bcna-$GETLAST-unix.zip"
BCNAHOME=/home/$BCNAUSER
BCNACONF=$BCNAHOME/.bitcanna
BCNADIR=$BCNAHOME/Bitcanna
BCNAPORT="12888"
}
####################################
clear
intro(){
cat<< EOF
##################################################################################
jjt                                  Script Contribution to BitCanna Community  ##
jjjj                                         To Ubuntu 18.04 LTS Server         ##
jjjjj                              ###############################################
jjjjj                                Executing this script you can Install and  ##
jjjjj   tjtj          jjjjjj             Configure your Bitcanna Wallet to:     ##
jjjjj jjjjjjjjj     jjjjjjjjjj                                                  ##
jjjtj jjjjjjjjjj   tjjjjjjtjjjj               - Stake (Proof-Of-Stake)          ##
jjjjjjjj    jjjjjijjjj      tjjj              - MN    (Master-Node)             ##
jjjjij        jjj jijjj                                                         ##
jjjjij         jjjjjj               ###############################################
jjjjjj         jjjjjj                                                           ##
jjtjjj         jjjjtj                          Project Ver: V1.9.8.15           ##
jjjjjj         jjjjj j                                                          ##
jjjjjjjj      jjjjjjjjjj,    tjjj           by DoMato aka hellresistor          ##
  jjjjjjjjjjjjjtjj jjjjjjjjjjjjj            Support donating Bitcanna           ##
   jjjjjjjjjjj jjj tjjjjjjjjjij                                                 ##
     jjjjjjjjj       jjjjijjjj        BCNA: B9bMDqgoAY7XA5bCwiUazdLKA78h4nGyfL  ##
##                                                                              ##
################################################################################## 
##################################################################################
##                                                                              ##
##  HAVE IN MIND!! EVERY TIME DO YOUR OWN BACKUPS BEFORE USING THIS SCRIPT      ##
##            I have NO responsability about system corruption!                 ##
##                     Use this Script at your own risk!                        ##
##                   (leave feedback, issues, suggestions)                      ##
##################################################################################
EOF
echo "Continue this Script are Accepting you are the only responsible"
read -n 1 -s -r -p "Press any key to Executing this Script"
sleep 2
}
choi(){
clear
cat<<EOF
#######################################
## BitCanna Wallet Installation Menu ##
#######################################
## Would you like Install/Configure) ##
##   P --> Full Node (P.O.Stake)     ##
##   M --> MasterNode (MN)?          ##
#######################################
EOF
read -n 1 -p "(P/M): " choiz;
case $choiz in
    p|P) echo ;;
    m|M) echo ;;
    *) echo "####################" && echo "## Really??? Missed!? ##" && echo "####################" && sleep 0.5 ;;
 esac
}
check(){
echo "###########################################" && echo "## Checking If script is running as root ##" && echo "###########################################" && sleep 1
if [ "root" != "$USER" ]
  then  sudo su -c "$0" root
  else
  echo "#########################################" && echo "## You are Root! Will Continue! wait.. ##" && echo "#########################################" && sleep 2
fi
}
getinfo(){
echo "#######################################" && echo "## Some questions to do before start ##"  && sleep 0.4 && echo "#######################################"
read -p"`echo -e '#######################################\n## What is New User to BCNA Wallet?:  '`" BCNAUSER 
varys
echo "#####################################" && echo "## Getting Public/External IP SRV ##" && echo "#####################################"
VPSIP="$(ip route get 8.8.8.8 | awk -F"src " 'NR==1{split($2,a," ");print a[1]}')"
echo "############################" && echo "## IP Its: $VPSIP ##" && echo "############################" && sleep 2
}
userad(){
clear
echo "##################################################" && echo "## Creating user to bitcanna and add to sudoers ##" && echo "##################################################"
adduser $BCNAUSER --shell=/bin/bash
usermod -aG sudo $BCNAUSER
cat <<ETF
##########################################################
##        Adding created user to SUDOERS list           ##
##########################################################
##           Sorry! You need do it by hand              ##
##            Make sure WILL BE like this:              ##
##########################################################
##########################################################
##   root ALL=(ALL:ALL) ALL                             ##
##   $BCNAUSER ALL=(ALL:ALL) ALL                       ## 
##########################################################
## MAKE SURE IS A <TAB-SPACE> BETWEEN $BCNAUSER and ALL ##
##########################################################
## Copy this line to easy things a little bit           ##
## $BCNAUSER ALL=(ALL:ALL) ALL                        ##
## You need PASTE below of line: root ALL=(ALL:ALL) ALL ##
##########################################################
ETF
read -n 1 -s -r -p "Press any key to continue to VISUDO" && visudo
echo "##################################################" && echo "## User $BCNAUSER Created and Permissions Added ##" && echo "##################################################" && sleep 2
}
bcnadown(){
clear
echo "###############################################################" && echo "## Lets Download and Extract the Bitcanna Wallet from GitHub ##" && echo "###############################################################"
wget -P $BCNAHOME $BCNAREP/$GETLAST/$BCNAPKG
mkdir $BCNADIR && unzip $BCNAHOME/$BCNAPKG && cp $EXTRACTEDPKG/* $BCNADIR && chmod -R 770 $BCNADIR && chown -R $BCNAUSER $BCNADIR && cp $EXTRACTEDPKG/* /usr/local/bin && chmod +x /usr/local/bin/bitcanna*
echo "###########################################" && echo "## Downloaded and Extracted to: $BCNADIR ##" && echo "###########################################" && sleep 1
}
service(){
clear
echo "###############################" && echo "## Creating bitcanna Service ##" && echo "###############################"
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
Restart=always
PrivateTmp=true
TimeoutStopSec=60s
TimeoutStartSec=2s
StartLimitInterval=120s
StartLimitBurst=5
[Install]
WantedBy=multi-user.target
EOF
cp /tmp/bitcannad.service /lib/systemd/system/bitcannad.service && systemctl enable bitcannad.service && rm /tmp/bitcannad.service
echo "##########################################" && echo "## BitCanna Service (bitcannad.service) ##" && echo "##########################################" && sleep 2
}
bypass(){
clear
echo "###################################################" && echo "## Preparing Script to Continue with user: $BCNAUSER ##" && echo "###################################################"
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
 echo "######################################################" && echo "## Have been Selected MasterNode - MN Configuration ##" && echo "######################################################" && sleep 5 && masternode
else
 echo "#####################################################" && echo "## Have been Selected FullNode - POS Configuration ##" && echo "#####################################################" && sleep 5 && stake
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
 echo "#############################################" &&  echo -n "Syncing... Wait more: "
 echo \$diff_t | awk '{printf "%d days, %d:%d:%d\n",\$1/(60*60*24),\$1/(60*60)%24,\$1%(60*60)/60,\$1%60}'
 sleep 5
done
}
firstrun(){
clear
echo "######################################" && echo "## Lets Initiate configurations ... ##" && echo "######################################" && sleep 0.5
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
read RPCUSR && echo "###########################################" && echo "## PASTE the line of rpcpassword=yyyyyyy ##"
echo "###########################################" && read RPCPWD && echo \$RPCUSR >> $BCNACONF/bitcanna.conf && echo \$RPCPWD >> $BCNACONF/bitcanna.conf
rm $BCNACONF/masternode.conf && echo "#################################" && echo "## Initial Configurations Done ##" && echo "#################################"
}
backup(){
clear
echo "###########################" && echo "## Backuping Wallet Info ##" && echo "###########################"
mkdir $BCNAHOME/BACKUP && chmod 700 $BCNAHOME/BACKUP
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
echo "#########################" && echo "## Compacting Files .. ##" && echo "#########################"
tar -zcvf $BCNAHOME/WalletBackup.tar.gz $BCNAHOME/BACKUP && chmod 500 $BCNAHOME/WalletBackup.tar.gz
cat<<EOF
#################################################################
## Info Wallet Backuped in: $BCNAHOME/WalletBackup.tar.gz 
##						                !!!PLEASE!!!	                          ##
##        SAVE THIS FILE ON MANY DEVICES ON SECURE             ##
#################################################################
EOF
sleep 5
}
cryptwallet(){
read -s -p "Set PassPhrase to wallet.dat: " WALLETPASS
echo "################################" && echo "##Please Wait a little bit... ##" && echo "################################"
WLTPSSCMD=\$"bitcanna-cli encryptwallet \$WALLETPASS"
\$WLTPSSCMD
sleep 15
echo "###################################################" && echo "## Restart BitCanna Wallet with Wallet Encrypted ##" && echo "###################################################"
bitcannad -daemon
sleep 15
WLTUNLOCK=\$"bitcanna-cli walletpassphrase \$WALLETPASS 0 false"
\$WLTUNLOCK
if [ "$choiz" == "p" ] || [ "$choiz" == "P" ]
 then
 clear && sleep 1 && echo "############################" && echo "## Set to Staking forever ##" && echo "############################" && sleep 0.5
  WLTUNLOCK=\$"bitcanna-cli walletpassphrase \$WALLETPASS 0 true"
  \$WLTUNLOCK
  sleep 2 && echo "##############" && echo "## Unlocked to Stake! ##" && echo "##############" && sleep 3 
  WLTSTAKE=\$"bitcanna-cli setstakesplitthreshold $STAKE"
  \$WLTSTAKE
  sleep 2 && echo "##############" && echo "## Staking with $STAKE ! ##" && echo "##############" && sleep 3
 fi
}
walletposconf(){
echo "staking=1" >> $BCNACONF/bitcanna.conf
clear && echo "####################" && echo "## Connecting ... ##" && echo "####################"
bitcannad -daemon 
sleep 10 && sync && echo "#############################" && echo "## Lets Check again ....!! ##" && echo "#############################" && sleep 5
sync && echo "#########################################################" && echo "## YES!! REALLY! Bitcanna Wallet Fully Syncronized!!! ##" && echo "#########################################################"
clear && echo "###########################" && echo "## My Wallet Address Is: ##" && echo "###########################"
WLTADRS=\$(bitcanna-cli getaccountaddress wallet.dat)
echo \$WLTADRS && cryptwallet
echo "################################################################################" && echo "## CONGRATULATIONS!! BitCanna POS - Proof-Of-Stake Configurations COMPLETED! ##" && echo "################################################################################" && sleep 3
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
clear && echo "####################" && echo "## Connecting ... ##" && echo "####################"
bitcannad -daemon 
sleep 10 && sync && echo "#############################" && echo "## Lets Check again ....!! ##" && echo "#############################" && sleep 5
sync && echo "#########################################################" && echo "## YES!! REALLY! Bitcanna Wallet Fully Syncronized!!! ##" && echo "#########################################################"
echo "##########################################" && echo "## Generate your MasterNode Private Key ##" && echo "##########################################"
MNGENK=\$(bitcanna-cli masternode genkey)
echo \$MNGENK
echo "####################################################" && echo "## Creating NEW Address to MASTERNODE -> \$MNALIAS ##" && echo "####################################################"
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
echo "externalip=$VPSIP" >> $BCNACONF/bitcanna.conf && echo "port=$BCNAPORT" >> $BCNACONF/bitcanna.conf
echo "\$IDMN \$MNALIAS $VPSIP:$BCNAPORT \$MNGENK \$MNTX \$MNID" > $BCNACONF/masternode.conf && cat $BCNACONF/masternode.conf
read -n 1 -s -r -p "`echo -e '\n#############################################################\n## Are you Verified The Results? Press any key to continue ##\n#############################################################\n '`" 
echo "#########################" && echo "## Run Bitcanna Wallet ##" && echo "#########################"
bitcannad --maxconnections=1000 -daemon
sleep 10 && echo "###############################" && echo "## Activating MasterNode ... ##" && echo "###############################"
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
clear && echo "#########################" && echo "## Cleaning the things ##" && echo "#########################"
rm $BCNADIR/bcna_unix_29_07_19
rm -R -f $BCNAHOME/BACKUP
rm $BCNAHOME/.bash_history
sed -i "/BCNA-Installer2.sh/d" $BCNAHOME/.bashrc
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
             ##                         Project Ver: V1.9.8.15                               ##
             ##                                                                              ##
             ##  by DoMato aka hellresistor                                                  ##
             ##                       Support donating Bitcanna                              ##
             ##  BCNA Address: B9bMDqgoAY7XA5bCwiUazdLKA78h4nGyfL                            ##
             ##                                                                              ##
             ##################################################################################
EOF
sleep 5
FOP
chmod 700 $BCNAHOME/BCNA-Installer2.sh && chown $BCNAUSER $BCNAHOME/BCNA-Installer2.sh
echo "$BCNAHOME/BCNA-Installer2.sh" >> $BCNAHOME/.bashrc
cat<<ETF
###################################################
## System ready for BitCanna Wallet installation ##
###################################################
##      !!!! Dont Forget To Continue !!!!        ##
##       Next Login, With User: $BCNAUSER         ##
###################################################
ETF
read -n 1 -s -r -p "Press any key to REBOOT" && echo "Rebooting..." && sleep 2 && reboot
}
mess(){
clear && sleep 0.5 && echo "#########################" && echo "## Cleaning the things ##" && echo "#########################"
rm $HOME/bcna_unix_29_07_19
rm $HOME/.bash_history
rm $BCNAHOME/$BCNAPKG
rm $BCNAHOME/$EXTRACTEDPKG
echo "##############################" && echo "## Cleaned garbage and tracks ##" && echo "##############################" && sleep 1
}
fwll(){
clear
echo "##############################" && echo "## Openning Port $BCNAPORT" ##" && echo "##  WILL FLASH ACTUAL RULES   ##" && echo "##############################" && sleep 5
#Lets do It SBasic ....
iptables -A INPUT -p tcp --dport $BCNAPORT
netfilter-persistent save
netfilter-persistent restart
read -n 1 -s -r -p "`echo -e '#########################################################################\n## PLEASE ITS APLLIED BASIC OPEN TO: 22, localhost and $BCNAPORT Ports ##\n##        And LAST BLOCK ALL!! Adapt your best firewall rules!!        ##\n#########################################################################\n Press any Key To Continue...'`"
}
intro
check
choi
getinfo
userad
bcnadown
service
fwll
bypass
mess
