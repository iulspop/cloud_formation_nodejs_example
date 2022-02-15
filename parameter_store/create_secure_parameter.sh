parameter_name=$1
secret=$2

aws ssm put-parameter --name $parameter_name \
  --value $secret \
  --type "SecureString"
