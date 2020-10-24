#!/bin/bash
set -o errexit
set -o pipefail
set -o nounset
set -o xtrace
# set -eox pipefail #safety for script

hostnamectl set-hostname elk-master
echo "192.168.50.15 elk-master.local elk-master" |sudo tee -a /etc/hosts
echo "192.168.50.16 elk-client01.local elk-client01" |sudo tee -a /etc/hosts
echo "192.168.50.17 elk-client02'.local elk-client02'" |sudo tee -a /etc/hosts
cat /etc/hosts

echo "nameserver 8.8.8.8" |sudo tee -a /etc/resolv.conf
cat /etc/resolv.conf

echo "===================================================================================="
                          hostnamectl status
echo "===================================================================================="
echo "         \   ^__^                                                                  "
echo "          \  (oo)\_______                                                          "
echo "             (__)\       )\/\                                                      "
echo "                 ||----w |                                                         "
echo "                 ||     ||                                                         "
echo "========================================================================================="


apt-get install -qqy software-properties-common apt-transport-https

# Java is required for the Elastic stack deployment.
# The repository 'http://ppa.launchpad.net/webupd8team/java/ubuntu focal Release' does not have a Release file
# add-apt-repository ppa:webupd8team/java -y
# apt-get install -qqy oracle-java8-installer
# java -version
# # Check the java binary file 
# update-alternatives --config java
# ls /usr/lib/jvm/java-8-oracle

# # create the profile file 'java.sh' under the 'profile.d' directory
# cat <<EOT | sudo tee /etc/profile.d/java.sh
# #Set JAVA_HOME
# JAVA_HOME="/usr/lib/jvm/java-8-oracle"
# export JAVA_HOME
# PATH=$PATH:$JAVA_HOME
# export PATH
# EOT
# cat /etc/profile.d/java.sh 

# # Make the file executable and load the configuration file
# chmod +x /etc/profile.d/java.sh
# source /etc/profile.d/java.sh

# make sure either Java 8 or Java 11 installed
apt-get update -qq && apt-get install -qqy default-jre

# check the java environment
echo $JAVA_HOME

# Install Elasticsearch
# Add the elastic stack key and add the elastic repository to the system.
wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add -
echo "deb https://artifacts.elastic.co/packages/6.x/apt stable main" | sudo tee -a /etc/apt/sources.list.d/elastic-6.x.list

# update the repository and install the elasticsearch package
apt-get update -qq && apt-get install -yqq elasticsearch 

# Uncomment the 'network.host' line and change the value to 'localhost', 
# and uncomment the 'http.port' line for the elasticsearch port configuration.
# network.host: localhost
# http.port: 9200
cat /etc/elasticsearch/elasticsearch.yml
# vim elasticsearch.yml

systemctl start elasticsearch
systemctl enable elasticsearch
systemctl status elasticsearch

netstat -plntu
curl -XGET 'localhost:9200/?pretty'

# Install and Configure Kibana Dashboard
apt-get install -yqq kibana 

# cd /etc/kibana/
# vim kibana.yml
# Uncomment those lines 'server.port', 'server.host', and 'elasticsearch.url'.
# server.port: 5601
# server.host: "localhost"
# elasticsearch.url: "http://localhost:9200"

systemctl start kibana
systemctl enable kibana
systemctl status kibana

# The kibana dashboard is now up and running on the 'localhost' address and the default port '5601'
netstat -plntu

# Install and Configure Nginx as Reverse-Proxy for Kibana
# the Nginx web server as a reverse proxy for the Kibana Dashboard.

apt-get install -yqq nginx apache2-utils 
