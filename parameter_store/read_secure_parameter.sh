parameter_name=$1
aws ssm get-parameter --name $parameter_name --with-decryption
