# Node.js Server Deploy and Configuration with AWS CloudFormation

This repo contains a CloudFormation template and scripts for automatically provisonning an EC2 instance and configuring it to run an Nginx web server and a Node.js application server. The Node app process is managed with PM2.

## What is CloudFormation?

CloudFormation is a tool for defining infrastructure as code. You create a template in a YAML or JSON file, then you can upload that template to CloudFormation and it will produce a stack based on the ressources and configuration defined in the template. Refer to the [CloudFormation documentation](https://docs.aws.amazon.com/cloudformation/?id=docs_gateway) to learn more.

## How to Get Started?

### Prerequisites
- [Install the AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html) and configure it with your account credentials.
- Create an [EC2 key pair](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ec2-key-pairs.html) and store the private in `~/.ssh` with appropriate permissions. You can run the `init_key_pair.sh` helper script once to create the desired key pair. Make sure `KeyName` property value under the EC2 ressource in the `fullstack-node.yaml` is the name of the EC2 key pair you created.
- Under "#### Clone & Install App ####" in the `setup_node_server.sh` file, you can change the GitHub repository to launch another Node.js server project. If it is a private repository, you must configure credentials on the EC2 instance.

### Create The Stack
Run `bash create_stack.sh` to start the stack. You can see in the AWS CloudFormation console that the stack is initialized and that CloudFormation starts provisioning ressources.

### Connect to EC2 Instance
After the EC2 instance has started and received an EIP (Elastic IP Address), you can connect to it via SSH by running `bash connect_ssh.sh $EC2_PUBLIC_IP`. You can find the instance's public IP in the EC2 console.

### Delete The Stack
Run `bash delete_stack.sh` to delete the stack. CloudFormation will delete the stack and the underlying ressources provisioned, including the EC2 instance. Great if you're playing around and want to spin up a server and delete it quickly.

## How It Works

`fullstack-node.yaml` is the CloudFormation template. It defines the ressources the CloudFormation stack will provision. To understand the template anatomy, refer to [this documentation](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/template-anatomy.html).

`create_stack.sh` send the template to CloudFormation and starts the stack. It also encodes the `setup_node_server.sh` script in Base64 and assigns the encoded string to `UserDataFile` parameter. User-data is the script run by cloud-init when the EC2 instance starts. By assigning the value to the parameter in this way, we can keep the script in a separate file instead of embedding it in the template. To learn more about UserData, refer to [this documentation](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/user-data.html).

`setup_node_server` is user-data script run by cloud init when the EC2 instances starts. It configures the EC2 instance to run an Express server. You may notice most of the script is saved to a file using `cat << EOF > setup_node_server.sh`, then the file is run as the ec2-user: `sudo -u ec2-user bash setup_node_server.sh`. User-data scripts run as the root user and you cannot change users using `su`. However, some installs and critically the Node server you want to run in user-space without root credientials. By saving the commands to a file and running the file as ec2-user, we can work around the restriction to just the root user. Since we create a second bash process running as a child of the parent bash process where we're logged in as root, the `$PATH` and `$HOME` environment variables of the root user envirnment are preserved and must be replaced manually.

## Debugging Tips
To debug userdata script in the EC2 instance, you can check the cloud-init logs to see the output of commands during init. You can see what script commands output to STDOUT if they ran. For example, your `echo` commands output.

Command to open the logs when logged in with SSH in the EC2 instance: `sudo vim /var/log/cloud-init-output.log`.