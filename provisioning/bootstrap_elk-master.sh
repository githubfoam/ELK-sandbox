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

echo "==================================Install Elastic Stack======================================================="
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
# echo $JAVA_HOME #JAVA_HOME: unbound variable

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
cp /vagrant/configs/elasticsearch.yml /etc/elasticsearch/elasticsearch.yml

systemctl start elasticsearch
systemctl enable elasticsearch
systemctl status elasticsearch

# required by netstat
apt-get install -yqq net-tools

netstat -plntu
curl -XGET 'localhost:9200/?pretty' #curl: (7) Failed to connect to localhost port 9200: Connection refused

echo "===============================# Install and Configure Kibana Dashboard=========================================================="
# Install and Configure Kibana Dashboard
apt-get install -yqq kibana 

# cd /etc/kibana/
# vim kibana.yml
# Uncomment those lines 'server.port', 'server.host', and 'elasticsearch.url'.
# server.port: 5601
# server.host: "localhost"
# elasticsearch.url: "http://localhost:9200"
cp /vagrant/configs/kibana.yml /etc/kibana/kibana.yml

systemctl start kibana
systemctl enable kibana
systemctl status kibana


# The kibana dashboard is now up and running on the 'localhost' address and the default port '5601'
netstat -plntu

echo "===============================# Install and Configure Nginx as Reverse-Proxy for Kibana=========================================================="
# the Nginx web server as a reverse proxy for the Kibana Dashboard.
apt-get install -yqq nginx apache2-utils 

#  create new virtual host file named 'kibana'
cp /vagrant/configs/kibana /etc/nginx/sites-available/kibana

# create new basic authentication web server for accessing the Kibana dashboard.
# htpasswd -c /etc/nginx/.kibana-user elastic

# Activate the kibana virtual host and test all nginx configuration.
ln -s /etc/nginx/sites-available/kibana /etc/nginx/sites-enabled/

nginx -t
# nginx: the configuration file /etc/nginx/nginx.conf syntax is ok
# nginx: configuration file /etc/nginx/nginx.conf test is successful

systemctl start nginx
systemctl enable nginx
systemctl status nginx

echo "===============================# Install and Configure Logstash=========================================================="
# check the OpenSSL Version
openssl version -a
# OpenSSL 1.1.1f  31 Mar 2020
# built on: Mon Apr 20 11:53:50 2020 UTC
# platform: debian-amd64
# options:  bn(64,64) rc4(16x,int) des(int) blowfish(ptr)
# compiler: gcc -fPIC -pthread -m64 -Wa,--noexecstack -Wall -Wa,--noexecstack -g -O2 -fdebug-prefix-map=/build/openssl-P_ODHM/openssl-1.1.1f=. -fstack-protector-strong -Wformat -Werror=format-security -DOPENSSL_TLS_SECURITY_LEVEL=2 -DOPENSSL_USE_NODELETE -DL_ENDIAN -DOPENSSL_PIC -DOPENSSL_CPUID_OBJ -DOPENSSL_IA32_SSE2 -DOPENSSL_BN_ASM_MONT -DOPENSSL_BN_ASM_MONT5 -DOPENSSL_BN_ASM_GF2m -DSHA1_ASM -DSHA256_ASM -DSHA512_ASM -DKECCAK1600_ASM -DRC4_ASM -DMD5_ASM -DAESNI_ASM -DVPAES_ASM -DGHASH_ASM -DECP_NISTZ256_ASM -DX25519_ASM -DPOLY1305_ASM -DNDEBUG -Wdate-time -D_FORTIFY_SOURCE=2
# OPENSSLDIR: "/usr/lib/ssl"
# ENGINESDIR: "/usr/lib/x86_64-linux-gnu/engines-1.1"
# Seeding source: os-specific

# Install logstash
apt-get install -yqq logstash  

# create new SSL directory under the logstash configuration directory '/etc/logstash' 
mkdir -p /etc/logstash/ssl && cd /etc/logstash/

# Generate the SSL certificate for Logstash
# The SSL certificate files for Logstash has been created on the '/etc/logstash/ssl' directory
openssl req -subj '/CN=elk-master/' -x509 -days 3650 -batch -nodes -newkey rsa:2048 -keyout ssl/logstash-forwarder.key -out ssl/logstash-forwarder.crt

# create a configuration file 'filebeat-input.conf' as input file from filebeat
cp /vagrant/configs/filebeat-input.conf /etc/logstash/conf.d/filebeat-input.conf

# create a configuration file 'syslog-filter.conf' for syslog processing
# For the syslog processing log data, use the filter plugin named 'grok' to parse the syslog files
cp /vagrant/configs/syslog-filter.conf /etc/logstash/conf.d/syslog-filter.conf

# create a configuration file 'output-elasticsearch.conf' file to define the Elasticsearch output
cp /vagrant/configs/output-elasticsearch.conf /etc/logstash/conf.d/output-elasticsearch.conf

systemctl start logstash
systemctl enable logstash
systemctl status logstash

# Check the logstash service  port '5443'.
netstat -plntu
