#!/bin/bash

set -xe

PROJECT_NAME=tf-first-project
ANSIBLE_SERVICE_ACCOUNT_NAME=ansible-sa
ANSIBLE_SERVICE_ACCOUNT_KEY_FILE_PATH=~/$ANSIBLE_SERVICE_ACCOUNT_NAME.json
ANSIBLE_SSH_KEY_FILE_PATH=~/.ssh/ssh-key-ansible
ROLES=('roles/compute.instanceAdmin' 'roles/compute.instanceAdmin.v1' 'roles/compute.osAdminLogin' 'roles/iam.serviceAccountUser')

# check gcloud config
# gcloud config configurations list
gcloud config set project $PROJECT_NAME

# create service account
gcloud iam service-accounts create ansible-sa --display-name $ANSIBLE_SERVICE_ACCOUNT_NAME
ANSIBLE_SERVICE_ACCOUNT_EMAIL=$(gcloud iam service-accounts list --format="json" | jq '.[].email' | grep $ANSIBLE_SERVICE_ACCOUNT_NAME | xargs )
echo "sa is $ANSIBLE_SERVICE_ACCOUNT_EMAIL"

# enable os-login project-wide
gcloud compute project-info add-metadata --metadata enable-oslogin=TRUE

# add roles
for role in ${ROLES[*]}
do
    gcloud projects add-iam-policy-binding $PROJECT_NAME \
        --member="serviceAccount:$ANSIBLE_SERVICE_ACCOUNT_EMAIL" \
        --role="$role"
done

# download service account json file
gcloud iam service-accounts keys create \
    $ANSIBLE_SERVICE_ACCOUNT_KEY_FILE_PATH \
    --iam-account=$ANSIBLE_SERVICE_ACCOUNT_EMAIL

# create ssh key pair
ssh-keygen -t rsa -N "" -f $ANSIBLE_SSH_KEY_FILE_PATH

# active service account
gcloud auth activate-service-account --key-file=$ANSIBLE_SERVICE_ACCOUNT_KEY_FILE_PATH

# add ssh key to service account
gcloud compute os-login ssh-keys add --key-file=$ANSIBLE_SSH_KEY_FILE_PATH.pub

################################################################################
# change back to tf service account to get wider access
gcloud auth activate-service-account --key-file=/home/rajesh_debian/.config/gcloud/tf-sa.json

# get id
id=$(gcloud iam service-accounts describe $ANSIBLE_SERVICE_ACCOUNT_EMAIL --format='value(uniqueId)')

# ssh user will be sa_id
# ssh -i ~/.ssh/ssh-key-ansible sa_id@ipaddress