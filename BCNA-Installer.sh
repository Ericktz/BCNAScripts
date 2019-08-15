#!/bin/bash
### Bitcanna Team!!
# Compile next Version the Programs directly into .ZIP no into folder
### Pleaaasseee :P
####################################
EXTRACTEDPKG=bcna_unix_29_07_19
####################################
varys(){
BCNAHOME=/home/$BCNAUSER
BCNACONF=$BCNAHOME/.bitcanna
BCNADIR=$BCNAHOME/Bitcanna
BCNAPORT="12888"
STAKE="100"    #<-- Can ChangeIt!! Sure yourself You Know What Are You Doing!!
}
####################################
clear
intro(){
cat<< EOF
##################################################################################
##                   Script Contribution to BitCanna Community                  ##
##                           To Ubuntu 18.04 LTS Server                         ##
##################################################################################
## Executing this script you can Install and Configure your Bitcanna Wallet to: ##
##                                                                              ##
##          - Stake (Proof-Of-Stake)                                            ##
##                                                                              ##
##          - MN    (Master-Node)                                               ##
##                                                                              ##
##################################################################################
##                                                                              ##
##      Project Status: V1.9.8                                                  ##
##                                                                              ##
##  by DoMato aka hellresistor                                                  ##
##  Support donating Bitcanna                                                   ##
##  BCNA Address: B9bMDqgoAY7XA5bCwiUazdLKA78h4nGyfL                            ##
##                                                                              ##
################################################################################## 
##################################################################################
##                                                                              ##
##  HAVE IN MIND!! EVERY TIME DO YOUR OWN BACKUPS BEFORE USING THIS SCRIPT      ##
##            I have NO responsability about system corruption!                 ##
##                     Use this Script at your own risk!                        ##
##                                                                              ##
##################################################################################
EOF
echo "Continue this Script are Accepting you are the only responsible"
read -n 1 -s -r -p "Press any key to Executing this Script"
clear
cat<< EIF
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
EIF
sleep 2
}
choi(){
clear
echo "#######################################" && echo "## BitCanna Wallet Installation Menu ##" && echo "#######################################"
read -n 1 -p "Would you like Configure, Full Node (P.O.Stake) or MasterNode (MN)? (P/M): " choiz;
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
read -p"`echo -e '##########################################################\n## What is New User to BCNA Wallet? (default. bitcanna):  '`" BCNAUSER 
varys
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
##   root	ALL=(ALL:ALL) ALL                             ##
##   $BCNAUSER	ALL=(ALL:ALL) ALL                       ## 
##########################################################
## MAKE SURE IS A <TAB-SPACE> BETWEEN $BCNAUSER and ALL ##
##########################################################
## Copy this line to easy things a little bit           ##
## $BCNAUSER	 ALL=(ALL:ALL) ALL                        ##
## You need PASTE below of line: root	ALL=(ALL:ALL) ALL ##
##########################################################
ETF
read -n 1 -s -r -p "Press any key to continue to VISUDO" && visudo
echo "##################################################" && echo "## User $BCNAUSER Created and Permissions Added ##" && echo "##################################################" && sleep 2
}
bcnadown(){
clear
echo "###############################################################" && echo "## Lets Download and Extract the Bitcanna Wallet from GitHub ##" && echo "###############################################################"
BCNAREP="https://github.com/BitCannaGlobal/BCNA/releases/download"
GETLAST=$(curl --silent "https://api.github.com/repos/BitCannaGlobal/BCNA/releases/latest" | grep -Po '"tag_name": "\K.*?(?=")')
BCNAPKG="bcna-$GETLAST-unix.zip"
wget -P $BCNAHOME $BCNAREP/$GETLAST/$BCNAPKG
mkdir $BCNADIR && unzip $BCNAHOME/$BCNAPKG && cp $EXTRACTEDPKG/* $BCNADIR && chmod -R 770 $BCNADIR && chown -R $BCNAUSER $BCNADIR && cp bcna_unix_29_07_19/* /usr/local/bin && chmod +x /usr/local/bin/bitcanna*
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
echo "##########################################" && echo "## Preparing Script to Continue with $BCNAUSER ##" && echo "##########################################"
cat<<FOH > $BCNAHOME/BCNA-Installer2.sh
 echo "Smeellllsss NIIICEEEE :D"
FOH
chmod 700 $BCNAHOME/BCNA-Installer2.sh && chown $BCNAUSER $BCNAHOME/BCNA-Installer2.sh
echo "$BCNAHOME/BCNA-Installer2.sh" >> $BCNAHOME/.bashrc
cat<<ETF
###################################################
## System ready for BitCanna Wallet installation ##
###################################################
##      !!!! Dont Forget To Continue !!!!        ##
##      Next Login, With User: $BCNAUSER         ##
###################################################
ETF
read -n 1 -s -r -p "Press any key to REBOOT" && echo "Rebooting..." && sleep 2 && reboot
}
mess(){
clear && sleep 0.5 && echo "#########################" && echo "## Cleaning the things ##" && echo "#########################"
rm $HOME/bcna_unix_29_07_19
rm $HOME/.bash_history
rm $BCNAHOME/$BCNAPKG
echo "##############################" && echo "## Cleaned garbage and tracks ##" && echo "##############################" && sleep 1
}
intro
check
choi
getinfo
userad
bcnadown
service
bypass
mess
