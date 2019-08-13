# BCNA Scripts

All configurations are following in Official Bitcanna Guides <https://www.bitcanna.io/guides/> 

This Script are prepared to Install and Configure a Bitcanna MasterNode or Bitcanna FullNode Wallet For Stake (PoS) on a Linux Virtual Private Server (VPS) with Ubuntu 18.04 LTS Server.

This script has composed with 2(two) Parts/steps files:
BCNA_Install.sh -> Run as ROOT USER to preparing the system to receive Bitcanna Wallet Software
BCNA_Continue.sh -> Will only used with User created and Its the Wallet Configuration Part

On Future will be joined into one only file Script.

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

# Support donating:
BCNA:  B9bMDqgoAY7XA5bCwiUazdLKA78h4nGyfL

# 420 Time
I hope all Bitcanna Team-Dev-Supporter-Investors-Cosummers-Community A Good enjoy of this script.
I am grateful to/get help/ed with knowlodgement contribution and retribution!

# Contributions
I every time open to new things to implementation. (Thank you Raul to help do this better)

# Contact me
Bitcanna Telegram Channel (https://t.me/joinchat/F4JfThITJB3cU-uaCwtKlQ)
