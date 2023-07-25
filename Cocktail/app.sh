#!/bin/bash

sleep 30

sudo apt update -y

sudo apt install -y gcc-c++ make
curl -sL https://rpm.nodesource.com/setup_14.x | sudo -E bash -
sudo apt install -y nodejs

sudo apt install unzip -y
cd ~/ && unzip cocktails.zip
cd ~/cocktails && npm i --only=prod

sudo mv /tmp/cocktails.service /etc/systemd/system/cocktails.service
sudo systemctl enable cocktails.service
sudo systemctl start cocktails.service