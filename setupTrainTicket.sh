#!/bin/bash

git clone https://github.com/docc-lab/train-ticket.git /local/train-ticket
sudo cp /local/repository/docker-train-ticket.sh /usr/bin/docker-train-ticket
sudo chmod +x /usr/bin/docker-train-ticket
sudo mkdir -p /local/checkpoints
sudo mkdir -p /local/checkpoints/train-ticket