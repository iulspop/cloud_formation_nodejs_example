aws cloudformation create-stack --stack-name fullstack-node \
  --template-body file://fullstack-node.yaml \
  --parameters ParameterKey=UserDataFile,ParameterValue=$(base64 -w0 setup_node_server.sh)