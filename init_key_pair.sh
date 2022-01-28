key_name=NodeServerKey
touch ~/.ssh/$key_name.pem
aws ec2 create-key-pair --key-name $key_name --query "KeyMaterial" --output text > ~/.ssh/$key_name.pem
chmod 400 ~/.ssh/$key_name.pem
echo "Key pair created succesfully and private key saved in ~/.ssh/"
