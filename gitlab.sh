#!/bin/bash
# sudo sh script_name
set -xe

# docker
# curl -fsSL https://get.docker.com -o get-docker.sh
# sudo sh get-docker.sh
# sudo usermod -aG docker $USER

PUBLIC_IP="34.93.19.14"
GITLAB_CONTAINER_NAME="gitlab"
JFROG_CONTAINER_NAME="artifactory"

sudo apt-get install jq -y

# gitlab
gitlab_container_state=$(docker inspect $GITLAB_CONTAINER_NAME | jq -r '.[].State.Status')
if [ $gitlab_container_state != "running" ]; then
sudo docker run --detach \
  --hostname gitlab.example.com \
  --env GITLAB_OMNIBUS_CONFIG="external_url 'http://$PUBLIC_IP'; gitlab_rails['lfs_enabled'] = true;" \
  --publish 443:443 --publish 80:80 --publish 2222:22 \
  --name $GITLAB_CONTAINER_NAME \
  --restart always \
  --volume /srv/gitlab/config:/etc/gitlab \
  --volume /srv/gitlab/logs:/var/log/gitlab \
  --volume /srv/gitlab/data:/var/opt/gitlab \
  gitlab/gitlab-ce:latest
fi

# jfrog
JFROG_HOME=/home/$USER
mkdir -p $JFROG_HOME/artifactory/var/etc/
cd $JFROG_HOME/artifactory/var/etc/
touch ./system.yaml
chown -R 1030:1030 $JFROG_HOME/artifactory/var
jfrog_container_state=$(docker inspect $JFROG_CONTAINER_NAME | jq -r '.[].State.Status')
if [ $jfrog_container_state != "running" ]; then
docker run --name $JFROG_CONTAINER_NAME -v $JFROG_HOME/artifactory/var/:/var/opt/jfrog/artifactory -d -p 8081:8081 -p 8082:8082 docker.bintray.io/jfrog/artifactory-cpp-ce:latest
fi

# runner
# curl -L https://packages.gitlab.com/install/repositories/runner/gitlab-runner/script.deb.sh | sudo bash
# sudo apt-get install gitlab-runner -y