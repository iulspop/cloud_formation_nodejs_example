ssh -i ~/.ssh/NodeServerKey.pem ec2-user@$1 -y

# use to debug userdata script
# sudo vim /var/log/cloud-init-output.log
