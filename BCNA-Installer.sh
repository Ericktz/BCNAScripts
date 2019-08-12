#!/bin/bash
clear
BCNAPKG=bcna-1.0.0-unix.zip
BCNASRCZIP="https://github.com/BitCannaGlobal/BCNA/releases/download/1.0.0/$BCNAPKG"

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
##      Project Status: CETI                                                    ##
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
BCNAHOME=/home/$BCNAUSER
BCNACONF=$BCNAHOME/.bitcanna
BCNADIR=$BCNAHOME/Bitcanna
}
userad(){
clear
echo "##################################################" && echo "## Creating user to bitcanna and add to sudoers ##" && echo "##################################################"
if [ "$BCNAUSER" == "bitcanna" ]
 then
  adduser bitcanna --shell=/bin/bash
 else
  adduser $BCNAUSER --shell=/bin/bash
fi
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
wget -P $BCNAHOME $BCNASRCZIP
mkdir $BCNADIR && unzip $BCNAHOME/$BCNAPKG -d $BCNADIR && mv $BCNADIR/bcna_unix_29_07_19/* $BCNADIR && chmod -R 770 $BCNADIR && chown -R $BCNAUSER $BCNADIR && cp $BCNADIR/bitcannad /usr/local/bin/bitcannad && chmod +x /usr/local/bin/bitcannad && cp $BCNADIR/bitcanna-cli /usr/local/bin/bitcanna-cli && chmod +x /usr/local/bin/bitcanna-cli
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
ExecStart=$BCNADIR/bitcannad -daemon -pid=$BCNACONF/bitcannad.pid -conf=$BCNACONF/bitcanna.conf -datadir=$BCNACONF
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
echo "##########################################" && echo "## Preparing to Next and Important STEP ##" && echo "##########################################"
cp $HOME/BCNAScripts/BCNA-Continue.sh $BCNAHOME/BCNA-Continue.sh && chmod 700 $BCNAHOME/BCNA-Continue.sh && chown $BCNAUSER $BCNAHOME/BCNA-Continue.sh
cat<<ETF
###################################################
## System ready for BitCanna Wallet installation ##
###################################################
##            !!!! Dont Forget !!!!              ##
##       Next Login With User: $BCNAUSER         ##
##         And run: ./BCNA-Continue.sh"          ##
###################################################
ETF
read -n 1 -s -r -p "Press any key to REBOOT" && echo "Rebooting..." && sleep 1 && reboot
}
cont(){
echo "Reserved to Join"
}
mess(){
clear && echo "#########################" && echo "## Cleaning the things ##" && echo "#########################"
rm $BCNADIR/bcna_unix_29_07_19
rm $BCNAHOME/.bash_history
rm $BCNAHOME/$BCNAPKG
echo "##############################" && echo "## Cleaned garbage and tracks ##" && echo "##############################" && sleep 1
}
intro
check
getinfo
userad
bcnadown
service
bypass
mess
