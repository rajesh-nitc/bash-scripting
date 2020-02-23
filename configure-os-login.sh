#!/bin/bash

set -xe

PROJECT_NAME=tf-first-project
ACCOUNT=rajesh.nitc.gcp@gmail.com
ANSIBLE_SERVICE_ACCOUNT_NAME=ansible-sa
ANSIBLE_SERVICE_ACCOUNT_KEY_FILEPATH=~/$ANSIBLE_SERVICE_ACCOUNT_NAME
ANSIBLE_SSH_KEYPAIR_NAME=ssh-key-ansible-sa
ANSIBLE_SSHKEY_FILEPATH=~/.ssh/$ANSIBLE_SSH_KEYPAIR_NAME
ROLES=('roles/compute.instanceAdmin' 'roles/compute.instanceAdmin.v1' 'roles/compute.osAdminLogin' 'roles/iam.serviceAccountUser')

# gcloud config configurations list
gcloud config set project $PROJECT_NAME

# create ansible service account
gcloud iam service-accounts create $ANSIBLE_SERVICE_ACCOUNT_NAME --display-name $ANSIBLE_SERVICE_ACCOUNT_NAME
ANSIBLE_SERVICE_ACCOUNT_EMAIL=$(gcloud iam service-accounts list --format="json" | jq '.[].email' | grep $ANSIBLE_SERVICE_ACCOUNT_NAME | xargs )
echo "ansible sa is $ANSIBLE_SERVICE_ACCOUNT_EMAIL"

# enable os-login
gcloud compute project-info add-metadata --metadata enable-oslogin=TRUE

# add roles
for role in ${ROLES[*]}
do
    gcloud projects add-iam-policy-binding $PROJECT_NAME --member="serviceAccount:$ANSIBLE_SERVICE_ACCOUNT_EMAIL" --role="$role"
done

# get sa json
gcloud iam service-accounts keys create $ANSIBLE_SERVICE_ACCOUNT_KEY_FILEPATH.json --iam-account=$ANSIBLE_SERVICE_ACCOUNT_EMAIL

# create ssh key-pair
ssh-keygen -t rsa -N "" -f $ANSIBLE_SSHKEY_FILEPATH

# activate sa
gcloud auth activate-service-account --key-file=$ANSIBLE_SERVICE_ACCOUNT_KEY_FILEPATH.json

# add ssh key
gcloud compute os-login ssh-keys add --key-file=$ANSIBLE_SSHKEY_FILEPATH.pub

# back to account
# gcloud config set account $ACCOUNT
# id=$(gcloud iam service-accounts describe $ANSIBLE_SERVICE_ACCOUNT_EMAIL --format='value(uniqueId)')
# ssh user will be sa_id
# ssh -i ~/.ssh/ssh-key-ansible sa_id@ipaddress
# source: https://alex.dzyoba.com/blog/gcp-ansible-service-account/
