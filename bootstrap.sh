#!/bin/bash

echo --------------------------------------------------
echo BEGIN BOOTSTRAP.SH
echo --------------------------------------------------

echo "nameserver 192.168.1.1" > /etc/resolv.conf

cd /vagrant

curl -s https://raw.githubusercontent.com/torch/ezinstall/master/install-deps | bash
su vagrant
git clone https://github.com/torch/distro.git ~/torch --recursive
cd ~/torch ; ./install.sh
source ~/.bashrc

echo --------------------------------------------------
echo VERIFY INSTALL
echo --------------------------------------------------

which th

echo --------------------------------------------------
echo END BOOTSTRAP.SH
echo --------------------------------------------------
