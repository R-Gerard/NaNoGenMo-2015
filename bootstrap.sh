#!/bin/bash

echo --------------------------------------------------
echo BEGIN BOOTSTRAP.SH
echo --------------------------------------------------

echo "nameserver 192.168.1.1" > /etc/resolv.conf

cd /vagrant

# Install RVM, Ruby, Rubygems, Bundler, and required gems
yum -y remove ruby

curl -L https://get.rvm.io | bash -s stable --ruby
source /usr/local/rvm/scripts/rvm
source /etc/profile.d/rvm.sh

bundle install

source /usr/local/rvm/scripts/rvm
source /etc/profile.d/rvm.sh

echo --------------------------------------------------
echo VERIFY INSTALL
echo --------------------------------------------------

rvm list
ruby -v
which ruby
gem -v
which gem
bundle -v
which bundle
gem list --local

echo --------------------------------------------------
echo END BOOTSTRAP.SH
echo --------------------------------------------------
