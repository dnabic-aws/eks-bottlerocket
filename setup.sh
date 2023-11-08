#!/bin/bash

echo '=== UPDATE system packages and INSTALL dependencies ==='
sudo yum update -y
sudo yum install -y vim git jq bash-completion moreutils gettext yum-utils perl-Digest-SHA tree

echo '=== ENABLE Amazon Extras EPEL Repository and INSTALL Git LFS ==='
sudo yum install -y amazon-linux-extras
sudo amazon-linux-extras install epel -y
sudo yum install -y git-lfs

echo '=== INSTALL AWS CLI v2 ==='
curl 'https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip' -o 'awscliv2.zip'
unzip awscliv2.zip -d /tmp
sudo /tmp/aws/install --update
rm -rf aws awscliv2.zip

echo '=== INSTALL Session Manager Plugin ==='
sudo yum install -y https://s3.amazonaws.com/session-manager-downloads/plugin/latest/linux_64bit/session-manager-plugin.rpm

echo '=== INSTALL Kubernetes CLI ==='
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
chmod +x kubectl && sudo mv kubectl /usr/local/bin/
/usr/local/bin/kubectl completion bash | sudo tee -a /etc/bash_completion.d/kubectl > /dev/null

echo '=== INSTALL Eksctl CLI ==='
curl --silent --location "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_$(uname -s)_amd64.tar.gz" | tar xz -C /tmp
sudo mv /tmp/eksctl /usr/local/bin
/usr/local/bin/eksctl completion bash | sudo tee -a /etc/bash_completion.d/eksctl > /dev/null

echo '=== SET AWS Environment Variables ==='
export AWS_ACCOUNT_ID="$(aws sts get-caller-identity --query Account --output text)" && echo "export AWS_ACCOUNT_ID=${AWS_ACCOUNT_ID}" >> /home/ec2-user/.bashrc
export AWS_REGION="$(curl -s http://169.254.169.254/latest/dynamic/instance-identity/document | grep region | cut -d'"' -f4)" && echo "export AWS_REGION=${AWS_REGION}" >> /home/ec2-user/.bashrc
