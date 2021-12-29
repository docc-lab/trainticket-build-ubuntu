#!/bin/bash

sudo apt install -y apt-transport-https ca-certificates curl software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu focal stable"
apt-cache policy docker-ce
sudo apt install -y docker-ce
sudo systemctl status docker --no-pager

for user in $(ls /users)
do
	sudo usermod -aG docker $user
done

sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
sudo docker-compose --version
sudo echo -e '\n\nexport PATH=$PATH:/usr/local/bin' >> .bashrc
source .bashrc

docker
docker-compose

sudo systemctl stop docker.service
sudo systemctl stop docker.socket

SEARCH_STRING="ExecStart=/usr/bin/dockerd -H fd://"
REPLACE_STRING="ExecStart=/usr/bin/dockerd -g /mydata/docker -H fd://"
sudo sed -i "s#$SEARCH_STRING#$REPLACE_STRING#" /lib/systemd/system/docker.service

sudo mkdir -p /mydata/docker
sudo rsync -aqxP /var/lib/docker/ /mydata/docker

sudo systemctl daemon-reload
sudo systemctl start docker