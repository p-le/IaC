#!/bin/bash
sudo yum update -y
sudo yum install -y wget git
yum groupinstall -y 'Development Tools'
sudo wget https://dl.yarnpkg.com/rpm/yarn.repo -O /etc/yum.repos.d/yarn.repo
curl --silent --location https://rpm.nodesource.com/setup_7.x | bash -
sudo yum -y install nodejs yarn
curl -O https://bootstrap.pypa.io/get-pip.py
sudo python get-pip.py
sudo pip install scikit-learn numpy
sudo /bin/dd if=/dev/zero of=/var/swap.1 bs=1M count=1024
sudo /sbin/mkswap /var/swap.1
sudo /sbin/swapon /var/swap.1
sudo pip install scipy
sudo swapoff /var/swap.1
sudo rm /var/swap.1
echo -e "ZONE=\"Asia/Tokyo\"" | sudo tee /etc/sysconfig/clock
sudo ln -sf /usr/share/zoneinfo/Asia/Tokyo /etc/localtime