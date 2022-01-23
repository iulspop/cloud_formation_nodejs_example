#!/bin/bash

echo "#### Switch from root to ec2-user ####"
su - ec2-user
cd ~
echo "Should logged into ec2-user:"
whoami

echo "#### Update packages ####"
sudo yum update -y

echo "#### Install NVM ####"
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash
. ~/.nvm/nvm.sh
nvm -v

echo "#### Install Node ####"
nvm install node
node -e "console.log('Running Node.js ' + process.version)"

echo "#### Install Git ####"
sudo yum install git -y

echo "#### Set Node permission to listen on Port 80 ####"
sudo setcap cap_net_bind_service=+ep /home/ec2-user/.nvm/versions/node/v17.4.0/bin/node

echo "#### Clone & Install App ####"
git clone https://github.com/iulspop/checkin-app-api.git
cd checkin-app-api/
npm install

echo "#### Start App ####"
node index.js
