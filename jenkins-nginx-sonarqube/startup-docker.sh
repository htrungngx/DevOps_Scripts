#!/bin/bash

sudo apt update -y & sudo apt upgrade -y 

sudo apt-get install -y \
    ca-certificates \
    curl \
    gnupg \
    lsb-release \
    software-properties-common

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt update

apt-cache policy docker-ce

sudo apt install -y docker-ce \
                    docker-ce-cli \
                    containerd.io \
                    docker-compose-plugin

sudo groupadd docker

sudo usermod -aG docker $USER

exit

sudo sysctl -w vm.max_map_count=262144