#!/bin/bash
# Script Contribution to BitCanna Community
# To Ubuntu Server 18.04
#
# STATUS: Developing
#
# by DoMato aka hellresistor
# Donate BCNA: B9bMDqgoAY7XA5bCwiUazdLKA78h4nGyfL
#

BCNAUSER=bitcanna
BCNAPKG=bcna-1.0.0-unix.zip
BCNAHOME=/home/$BCNAUSER
BCNADIR=$BCNAHOME/Bitcanna
STAKE=100

check(){
echo "Checking as running as root user"
sleep 1
if [ "root" != "$USER" ]
  then  sudo su -c "$0" root
  exit
fi
}

userad(){
echo "Creating user to bitcanna and add to sudoers"
adduser $BCNAUSER --shell=/bin/bash
usermod -aG sudo $BCNAUSER
echo "Soorrryy You need do it by hand" && echo && echo
echo "!!!!!!!!!!!!!!!! COPY THIS LINE BELOW !!!!!!!!!!!!!!!!" 
echo "SeCuRe if exist A <TAB> between $BCNAUSER-	-ALL=(ALL:ALL) ALL when pasting"
echo && echo
echo "$BCNAUSER	ALL=(ALL:ALL) ALL" && echo && echo
echo "You need PASTE THAT above of this line: root	ALL=(ALL:ALL) ALL"
read -n 1 -s -r -p "Press any key to continue to VISUDO"
visudo
}

service(){
cat <<EOF> /tmp/bitcannad.service
[Unit]
Description=BCNAs distributed currency daemon EDITED by hellresistor
After=network.target
[Service]
User=$BCNAUSER
Group=$BCNAUSER
Type=forking
PIDFile=$BCNAHOME/.bitcanna/bitcannad.pid
ExecStart=$BCNADIR/bitcannad -daemon -pid=$BCNAHOME/.bitcanna/bitcannad.pid -conf=$BCNAHOME/.bitcanna/bitcanna.conf -datadir=$BCNAHOME/.bitcanna
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
cp /tmp/bitcannad.service /lib/systemd/system/bitcannad.service
systemctl enable bitcannad.service
rm /tmp/bitcannad.service
}

bypass(){
 cp vars $BCNAHOME/vars
cp BCNA-Continue.sh $BCNAHOME/BCNA-Continue.sh
chown bitcanna /home/bitcanna/BCNA-Continue.sh
chmod 777 /home/bitcanna/BCNA-Continue.sh
 chmod 777 $BCNAHOME/vars
 chown $BCNAUSER $BCNAHOME/vars
 echo && echo "Dont Forget" && echo && sleep 2
 echo "Next Login With - $BCNAUSER - user"
## YES LAMME KID .... On future will be auto .. not time to that now =D
 echo "And run ./cont.sh"
 ## nhhheee... Workin an other thing :P
 echo
 read -n 1 -s -r -p "Press any key to REBOOT"
 echo "Rebooting..." && sleep 1 && reboot
}

bypass2(){
cat <<FOE> $BCNAHOME/Continue.sh
#!/bin/bash
check(){
echo "Checking as running as bitcanna user"
sleep 1
if [ "$BCNAUSER" != "\$USER" ]
  then  sudo su -c "$0" $BCNAUSER
  exit
fi
}
check
whoime
FOE

#chmod 777 $BCNAHOME/BCNA-Continue.sh
#chown $BCNAUSER $BCNAHOME/BCNA-Continue.sh
#echo "Run ./BCNA-Continue.sh"
echo
read -n 1 -s -r -p "Press any key to REBOOT"
#echo "Rebooting..." && sleep 1 && reboot
}

check
checkapt
userad
service
#bypass
bypass2
