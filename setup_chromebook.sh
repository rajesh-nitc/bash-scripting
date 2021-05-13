#!/bin/bash

# enable debugging
set -x

# abort on error
set -e

TERRAFORM_VERSION=0.13.0
TERRAFORM_DOCS_VERSION=0.10.1
KUSTOMIZE_VERSION=3.9.2

sudo apt-get install -y apt-transport-https ca-certificates gnupg dnsutils zip gawk unzip software-properties-common

# vs code
wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
sudo install -o root -g root -m 644 packages.microsoft.gpg /etc/apt/trusted.gpg.d/
sudo sh -c 'echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/trusted.gpg.d/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list'
sudo apt-get update
sudo apt-get install -y code
rm packages.microsoft.gpg

# gcloud sdk
echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" | sudo tee -a /etc/apt/sources.list.d/google-cloud-sdk.list
curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key --keyring /usr/share/keyrings/cloud.google.gpg add -
sudo apt-get update
sudo apt-get install -y google-cloud-sdk kubectl

# terraform
curl -k -O https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip
unzip terraform_${TERRAFORM_VERSION}_linux_amd64.zip
sudo mv terraform /usr/local/bin/
rm terraform_${TERRAFORM_VERSION}_linux_amd64.zip

# terraform-docs
curl -k -LO https://github.com/terraform-docs/terraform-docs/releases/download/v${TERRAFORM_DOCS_VERSION}/terraform-docs-v${TERRAFORM_DOCS_VERSION}-linux-amd64
mv terraform-docs-v${TERRAFORM_DOCS_VERSION}-linux-amd64 terraform-docs
chmod +x terraform-docs
sudo mv terraform-docs /usr/local/bin

# kustomize
curl -k -LO https://github.com/kubernetes-sigs/kustomize/releases/download/kustomize%2Fv${KUSTOMIZE_VERSION}/kustomize_v${KUSTOMIZE_VERSION}_linux_amd64.tar.gz
tar xzf kustomize_v${KUSTOMIZE_VERSION}_linux_amd64.tar.gz
sudo mv kustomize /usr/local/bin
rm kustomize_v${KUSTOMIZE_VERSION}_linux_amd64.tar.gz

# python
sudo apt install -y python3 python3-dev python3-venv python3-pip

# jupyter notebook
pip3 install jupyterlab
pip3 install bash_kernel
python3 -m bash_kernel.install

# pre-commit terraform
pip3 install pre-commit
export PATH=$PATH:/home/$USER/.local/bin
