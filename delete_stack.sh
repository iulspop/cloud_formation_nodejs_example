stack_name=fullstack-node

aws cloudformation delete-stack --stack-name $stack_name

echo "Waiting for stack deletion to complete..."
aws cloudformation wait stack-delete-complete --stack-name $stack_name
