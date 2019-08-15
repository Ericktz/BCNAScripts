# BCNA Scripts

This is a Contribuition Script! Is not Official or Developed by Bitcanna.io Team!

All configurations are following the Officials Bitcanna Guides <https://www.bitcanna.io/guides/> 

This Script are prepared to Install and Configure a Bitcanna MasterNode or Bitcanna FullNode Wallet For Stake (PoS) on a Linux Virtual Private Server (VPS) with Ubuntu 18.04 LTS Server.

This script has composed with 2(two) Parts/steps files:
BCNA_Install.sh -> Run as ROOT USER to preparing the system to receive Bitcanna Wallet And Dedicated user
BCNA_Continue.sh -> Will only used with User created! When you choose you like SetUp a BitCanna Full Node (PoS) or MasterNode (MN)
(*) In time will be joined into one file only.

# !!!!ATTENTION!!!!!
To Run the MasterNode YOU NEED AT LEAST 100K (100.000) of BCNA (BitCanna Coins)!!
Please, Read the BitCanna WhitePaper at https://www.bitcanna.io/whitepaper/
Please, Protect your SERVER! Can use this script to Hardening Server (https://github.com/konstruktoid/hardening.git) or Do an Server Audit with Lynis (https://github.com/CISOfy/lynis.git). PS: This Scripts are in development/Update/Upgrade every time. Sure you have know what are you doing!

# STATUS: *V1.9.8*

*Script Container:*
-->BCNA_Install.sh
   - Create Username to Bitcanna Wallet
   - Prepare User to sudo (visudo)
   - Download and Extract bcna-1.0.0-unix.zip
   - Configure Bitcanna run as Service
--> BCNA_Continue.sh
   - Configuration Bitcanna FullNode to Proof-of-Stake (see BCNA FullNode Guide)
   - Configuration Bitcanna MasterNode (see BCNA MasterNode Guide)
   - Adding bitcanna AS BINary (just type: $ bitcannd OR $ bitcanna-cli )
   - Encrypt wallets with password/passphrase
   - Backup (wallet.dat + wallet address + dumpprivkey + wallet pass = Backup.tar.gz)
   - Final Cleaning and Fresh Running

# Requirements: 
$ apt update && apt upgrade -y && apt install -y git unzip

# Run:
$ git clone https://github.com/hellresistor/BCNAScripts.git && chmod 770 -R BCNAScripts && ./BCNAScripts/BCNA-Installer.sh

# $ Please, Check all code! Not Judge me before read it!  $
 
# Support donating:
If you like, as usefull, or take you a much pain of time
fell free do donating some CBD with BCNA.
BCNA:  B9bMDqgoAY7XA5bCwiUazdLKA78h4nGyfL

# 420 Time
With many 420 Times and Dedication
I hope all Bitcanna Team-Dev-Supporter-Investors-Cosummers-Community A Good enjoy of this script. And have a good reduce on THC use :P
I am grateful to/get help/ed with knowlodgement contribution and retribution!

# Contributions
Its every time open to new things to implementation. 
(Thank you ALL to help to do this better)

# Contact on
Bitcanna Telegram Channel (https://t.me/joinchat/F4JfThITJB3cU-uaCwtKlQ)

# Extra
 Need a VPS to run MasterNode?? 
Time4VPS: https://www.time4vps.com/?affid=4335
 Need Get Some BitCannas To Staking or MasterNode?
Coin Deal: https://coindeal.com/ref/AV4X
Stex: https://app.stex.com/?ref=75177165
