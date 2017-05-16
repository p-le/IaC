#!/bin/bash
yum install -y wget git
wget https://dl.yarnpkg.com/rpm/yarn.repo -O /etc/yum.repos.d/yarn.repo
curl --silent --location https://rpm.nodesource.com/setup_7.x | bash -
yum -y install nodejs yarn
curl -O https://bootstrap.pypa.io/get-pip.py
python get-pip.py
pip install scikit-learn numpy
/bin/dd if=/dev/zero of=/var/swap.1 bs=1M count=1024
/sbin/mkswap /var/swap.1
/sbin/swapon /var/swap.1
pip install scipy
swapoff /var/swap.1
rm /var/swap.1
echo -e "ZONE=\"Asia/Tokyo\"" | sudo tee /etc/sysconfig/clock
ln -sf /usr/share/zoneinfo/Asia/Tokyo /etc/localtime
git clone https://github.com/p-le/ai-api-backend.git
chmod a+x /ai-api-backend/start.sh
. /ai-api-backend/start.sh
yarn install
HASH_KEY=netmile ./node_modules/.bin/pm2 start index.js
EXPORT PM2_HOME=/etc/.pm2