key_name=EC2ServerKey

# Create .ssh directory if it doesn't exist
if [ ! -d ~/.ssh ]; then
    mkdir -p ~/.ssh
    if [ $? -ne 0 ]; then
        echo "Failed to create .ssh directory."
        exit 1
    fi
fi

# Create .pem file
touch ~/.ssh/$key_name.pem
if [ $? -ne 0 ]; then
    echo "Failed to create .pem file."
    exit 1
fi

# Create EC2 key pair and write to the .pem file
aws ec2 create-key-pair --key-name $key_name --query "KeyMaterial" --output text > ~/.ssh/$key_name.pem
if [ $? -ne 0 ]; then
    echo "Failed to create EC2 key pair."
    exit 1
fi

# Change permissions of the .pem file
chmod 400 ~/.ssh/$key_name.pem
if [ $? -ne 0 ]; then
    echo "Failed to set permissions on .pem file."
    exit 1
fi

echo "Key pair created successfully and private key saved in ~/.ssh/"
