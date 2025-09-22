#!/bin/bash

# APT
sudo apt update
sudo apt upgrade -y
sudo apt autoremove -y
echo
echo

echo Updating Qu1cksc0pe
###############
cd ~/Qu1cksc0pe
git pull

# After cloning the repository you must create a python virtual environment (for handling python modules)
source .venv/bin/activate

# You can simply execute the following command it will do everything for you!
bash setup.sh

# If you want to install Qu1cksc0pe on your system just execute the following commands.
python3 qu1cksc0pe.py --install

deactivate
###############
echo
echo

echo Updating pyinstxtractor
cd ~/pyinstxtractor
git pull
echo
echo

echo Updating SQLMap
cd ~/sqlmap-dev
git pull
echo
echo

echo Updating Burp Suite
cd ~/scripts
python3 burpsuite-update.py
echo
echo


echo Updating Ghidra
cd /tmp
url=$(curl -s https://api.github.com/repos/NationalSecurityAgency/ghidra/releases/latest | jq -r '.assets[0].browser_download_url')
wget -O ghidra.zip "$url"
unzip -o ghidra.zip
cp -R ghidra_*_PUBLIC/* ~/ghidra/
echo
echo

echo Updating Autopsy
cd /tmp
AUTOPSY_BASE_PATH=~/autopsy
TAG_NAME=$(curl -s https://api.github.com/repos/sleuthkit/autopsy/releases/latest | jq -r .tag_name)
if [ -d "$AUTOPSY_BASE_PATH/$TAG_NAME" ]; then
    echo "[+] Autopsy est à jour."
else
    echo "[!] Nouvelle version d'Autopsy : $TAG_NAME"
    cd /tmp

    # Install sleuthkit
    sleuthkit_url=$(curl -s https://api.github.com/repos/sleuthkit/sleuthkit/releases/latest | jq -r '.assets[4].browser_download_url')
    wget -O sleuthkit.deb "$sleuthkit_url"
    sudo apt install -y ./sleuthkit.deb
    
    # Install autopsy
    autopsy_url=$(curl -s https://api.github.com/repos/sleuthkit/autopsy/releases/latest | jq -r '.assets[1].browser_download_url')
    wget -O autopsy.zip "$autopsy_url"
    rm -rf ~/autopsy/*
    unzip -o autopsy.zip -d ~/autopsy/
fi

# End
echo
echo
read -rsp $'Done. Press enter to continue. Reboot recommended. \n'
echo
