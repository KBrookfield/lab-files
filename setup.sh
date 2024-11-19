#!/bin/bash

set -e  # Exit immediately if a command exits with a non-zero status

# Update packages
echo "Updating package lists and upgrading installed packages..."
sudo apt-get update && sudo apt-get upgrade -y

# Install tools
echo "Installing essential tools..."
sudo apt install -y ca-certificates curl wget gnupg net-tools zip unzip jq make zsh bat bash-completion whois

# Install kubectl
echo "Installing kubectl..."
curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.28/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
echo "deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.28/deb/ /" | sudo tee /etc/apt/sources.list.d/kubernetes.list
sudo apt-get update && sudo apt-get install -y kubectl

# Install kubectl-vsphere plugin
echo "Installing kubectl-vsphere plugin..."
curl -ks https://192.168.30.34/wcp/plugin/linux-amd64/vsphere-plugin.zip -o /tmp/vsphere-plugin.zip
unzip -qn /tmp/vsphere-plugin.zip -d /tmp
sudo install /tmp/bin/kubectl-vsphere /usr/local/bin

# Install vCenter certificates
echo "Installing vCenter certificates..."
wget https://vcenter-01.vmw.lab/certs/download.zip --no-check-certificate
unzip download.zip
cp certs/lin/351d2e9c.0 ca.crt
sudo cp ca.crt /usr/local/share/ca-certificates
sudo update-ca-certificates

# Install Docker
echo "Installing Docker..."
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh
sudo usermod -aG docker ubuntu

# Install Carvel tools
echo "Installing Carvel tools..."
wget -O- https://carvel.dev/install.sh > install.sh
sudo bash install.sh

# Install Packer
echo "Installing Packer..."
curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
sudo apt-get update && sudo apt-get install -y packer

# Install Ansible
echo "Installing Ansible..."
sudo add-apt-repository --yes --update ppa:ansible/ansible
sudo apt install -y ansible

# Install Packer plugins
echo "Installing Packer plugins..."
packer plugins install github.com/hashicorp/vsphere
packer plugins install github.com/hashicorp/ansible

echo "Setup completed successfully!"
