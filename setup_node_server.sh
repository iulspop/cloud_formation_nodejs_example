#! /bin/bash

yum update -y
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash
nvm install 17.4.0

git clone https://github.com/iulspop/checkin-app-api.git
cd checkin-app-api/
npm install
npm start
