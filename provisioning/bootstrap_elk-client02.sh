#!/bin/bash
set -o errexit
set -o pipefail
set -o nounset
set -o xtrace
# set -eox pipefail #safety for script

hostnamectl set-hostname client02
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

# Install and Configure Filebeat on CentOS

# Copy the logstash certificate file 'logstash-forwarder.crt' using
# scp root@elk-master:/etc/logstash/ssl/logstash-forwarder.crt .

#  install the Elastic Beats 'Filebeat' by adding the elastic key 
# and add the elastic repository
rpm --import https://artifacts.elastic.co/GPG-KEY-elasticsearch
 
cat <<EOF > /etc/yum.repos.d/elastic.repo
[elasticsearch-6.x]
name=Elasticsearch repository for 6.x packages
baseurl=https://artifacts.elastic.co/packages/6.x/yum
gpgcheck=1
gpgkey=https://artifacts.elastic.co/GPG-KEY-elasticsearch
enabled=1
autorefresh=1
type=rpm-md
EOF

# Install filebeat
yum install filebeat -y

# go to the '/etc/filebeat' directory 
# and edit the configuration file 'filebeat.yml'
# cd /etc/filebeat/
# vim filebeat.yml
# enable the filebeat prospectors by change the 'enabled' line value to 'true'.
# enabled: true
# Define system log files to be sent to the logstash server.
# add the ssh log file 'auth.log' and the syslog file
#   paths:
#     - /var/log/secure
#     - /var/log/messages
# Setup the output to logstash by commenting the default 'elasticsearch' output and uncomment the logstash output line
# output.logstash:
#   # The Logstash hosts
#   hosts: ["elk-master:5443"]
#   ssl.certificate_authorities: ["/etc/filebeat/logstash-forwarder.crt"]

# edit the 'filebeat.reference.yml' file to enable filebeat modules
# enable the 'syslog' module.
# vim filebeat.reference.yml
# Enable the syslog system module for filebea
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