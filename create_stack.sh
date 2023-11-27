stack_name=fullstack-node

if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    encoded_string=$(base64 -w0 setup_node_server.sh)
elif [[ "$OSTYPE" == "darwin"* ]]; then
    encoded_string=$(base64 -i setup_node_server.sh)
else
    echo "Unsupported operating system"
    exit 1
fi

aws cloudformation create-stack --stack-name $stack_name \
  --template-body file://fullstack-node.yaml \
  --parameters ParameterKey=UserDataFile,ParameterValue=$encoded_string \
  --capabilities CAPABILITY_NAMED_IAM

echo -e "\nWaiting for stack creation to complete to show stack outputs..."
aws cloudformation wait stack-create-complete --stack-name $stack_name
aws cloudformation describe-stacks --stack-name $stack_name --query "Stacks[0].Outputs[?OutputKey=='InstanceIPAddress'].OutputValue" --output text
