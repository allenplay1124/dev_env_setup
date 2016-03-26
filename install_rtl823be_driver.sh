#!/bin/bash

sudo apt-get install -y linux-headers-generic build-essential git
git clone https://github.com/lwfinger/rtlwifi_new.git
cd rtlwifi_new
sudo make && sudo make install
sudo modprobe -r rtl8723be
sudo modprobe rtl8723be
