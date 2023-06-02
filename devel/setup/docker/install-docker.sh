#!/bin/bash
cd "$(dirname "$0")"

echo " "
echo "## INSTALL DOCKER ###############################################"
source getPKMG.sh
if [ "$PKMG" == "yum" ]; then
  sudo yum install -y yum-utils device-mapper-persistent-data lvm2
  sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
  sudo yum install -y docker-ce docker-ce-cli containerd.io
else
  sudo apt install -y apt-transport-https ca-certificates curl \
    gnupg-agent software-properties-common
  curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
  sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) stable"
  sudo apt update
  sudo apt install -y docker-ce docker-ce-cli containerd.io
fi


sudo systemctl enable docker
sudo systemctl start docker
sudo usermod -aG docker $USER

exit 0
