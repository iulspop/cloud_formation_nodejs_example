#!/bin/bash

echo "#### Update packages ####"
yum update -y

echo "#### Install & Configure PostgreSQL ####"
amazon-linux-extras enable postgresql13
yum clean metadata
yum install -y postgresql postgresql-server postgresql-libs
postgresql-setup --initdb
systemctl start postgresql.service
systemctl enable postgresql.service
su postgres -c "createuser --createdb ec2-user"

echo "#### Install & Start MongoDB ####"
cat << EOF > /etc/yum.repos.d/mongodb-org-5.0.repo
[mongodb-org-5.0]
name=MongoDB Repository
baseurl=https://repo.mongodb.org/yum/amazon/2/mongodb-org/5.0/x86_64/
gpgcheck=1
enabled=1
gpgkey=https://www.mongodb.org/static/pgp/server-5.0.asc
EOF
yum install -y mongodb-org
systemctl start mongod
systemctl enable mongod

echo "#### Install & Configure & Start Nginx ####"
amazon-linux-extras install -y nginx1
cd /etc/nginx
touch default.d/default.conf
echo "location / { proxy_pass http://localhost:3000; }" > default.d/default.conf
systemctl start nginx
systemctl enable nginx

echo "#### Install Git ####"
yum install git -y

cat << EOF > setup_node_server.sh
  $HOME=/home/ec2-user
  $PATH=/usr/local/bin:/usr/bin:/usr/local/sbin:/usr/sbin:/home/ec2-user/.local/bin:/home/ec2-user/bin

  echo "#### Should be logged into ec2-user ####"
  whoami
  cd ~
  pwd

  echo "#### Configure AWS CLI Region ####"
  mkdir .aws
  echo -e "[default]\nregion=us-east-1" > .aws/config

  echo "#### Install NVM ####"
  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash
  . ~/.nvm/nvm.sh
  nvm -v

  echo "#### Install Node ####"
  nvm install node
  nvm use node
  node -e "console.log('Running Node.js ' + process.version)"

  echo "#### Clone & Install App ####"
  git clone https://github.com/iulspop/checkin-app-api.git
  cd checkin-app-api/
  npm install

  echo "### Install PM2 ####"
  npm install pm2@latest -g

  echo "#### Start App ####"
  PORT=3000 NODE_ENV=production pm2 start index.js --name checkin_app --update-env
EOF

sudo -u ec2-user bash setup_node_server.sh
