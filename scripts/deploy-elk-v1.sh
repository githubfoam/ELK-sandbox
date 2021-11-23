#!/usr/bin/env bash

set -o errexit
# set -o pipefail #Illegal option -o pipefail
set -o nounset
set -o xtrace
# set -euo pipefail

echo "===================================================================================="
apt-get update

# Install JDK on Ubuntu
sudo apt-get install openjdk-11-jdk wget apt-transport-https curl gnupg2 -y
java -version

#1: Install and Configure ElasticSearch on Ubuntu
wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch --no-check-certificate | sudo apt-key add -

echo "deb https://artifacts.elastic.co/packages/7.x/apt stable main" | sudo tee -a /etc/apt/sources.list.d/elastic-7.x.list
apt-get update


echo "===================================================================================="
