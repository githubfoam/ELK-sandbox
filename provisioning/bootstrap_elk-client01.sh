#!/bin/bash
set -o errexit
set -o pipefail
set -o nounset
set -o xtrace
# set -eox pipefail #safety for script

hostnamectl set-hostname elk-client01
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

# Install and Configure Filebeat on Ubuntu 18.04
# configure the Ubuntu 18.04 client 'elk-client01' 
# by installing the Elastic Beats data shippers 'Filebeat' on it

# download the logstash certificate file 'logstash-forwarder.crt' file to the 'elk-client01' server.
# Copy the logstash certificate file 'logstash-forwarder.crt' 
# scp root@elk-master:/etc/logstash/ssl/logstash-forwarder.crt .

# install the Elastic Beats 'Filebeat' by adding the elastic key 
# and add the elastic repository
wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add -
echo "deb https://artifacts.elastic.co/packages/6.x/apt stable main" | sudo tee -a /etc/apt/sources.list.d/elastic-6.x.list
# Update the repository and install the 'filebeat'
apt-get update -qq && apt-get install -yqq filebeat 

# edit the configuration file 'filebeat.yml'
# cd /etc/filebeat/
# vim filebeat.yml
# Now enable the filebeat prospectors by changing the 'enabled' line value to 'true'.
# enabled: true
# add the ssh log file 'auth.log' and the syslog file
# paths:
#     - /var/log/auth.log
#     - /var/log/syslog
# Setup the output to logstash by commenting the default 'elasticsearch' output and uncomment the logstash output line
# output.logstash:
#   # The Logstash hosts
#   hosts: ["elk-master:5443"]
#   ssl.certificate_authorities: ["/etc/filebeat/logstash-forwarder.crt"]

# edit the 'filebeat.reference.yml' file to enable filebeat modules, 
# and enable the 'syslog' module
# vim filebeat.reference.yml
# Enable the syslog system module for filebeat
# - module: system
#   # Syslog
#   syslog:
#     enabled: true

# Copy the logstash certificate file 'logstash-forwarder.crt' to the '/etc/filebeat' directory.
# cp ~/logstash-forwarder.crt /etc/filebeat/logstash-forwarder.crt

systemctl start filebeat
systemctl enable filebeat
systemctl status filebeat
tail -n 40 /var/log/filebeat/filebeat