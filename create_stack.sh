stack_name=fullstack-node

aws cloudformation create-stack --stack-name $stack_name \
  --template-body file://fullstack-node.yaml \
  --parameters ParameterKey=UserDataFile,ParameterValue=$(base64 -w0 setup_node_server.sh) \
  --capabilities CAPABILITY_NAMED_IAM

echo -e "\nWaiting for stack creation to complete to show stack outputs..."
aws cloudformation wait stack-create-complete --stack-name $stack_name
aws cloudformation describe-stacks --stack-name $stack_name --query "Stacks[0].Outputs[?OutputKey=='InstanceIPAddress'].OutputValue" --output text
