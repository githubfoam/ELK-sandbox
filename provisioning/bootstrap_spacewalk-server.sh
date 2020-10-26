#!/bin/bash
set -o errexit
set -o pipefail
set -o nounset
set -o xtrace
# set -eox pipefail #safety for script

hostnamectl set-hostname elk-master
echo "192.168.1.20 spacewalk-server.local spacewalk-server" |sudo tee -a /etc/hosts
echo "192.168.1.21 spacewalk-client01.local spacewalk-client01" |sudo tee -a /etc/hosts
echo "192.168.1.22 spacewalk-client02.local spacewalk-client02" |sudo tee -a /etc/hosts
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

# https://github.com/spacewalkproject/spacewalk/wiki/HowToInstall
echo "================================== Spacewalk Installation ======================================================="

# Setting up Spacewalk repo
yum install -yq yum-plugin-tmprepo
yum install -yq spacewalk-repo --tmprepo=https://copr-be.cloud.fedoraproject.org/results/%40spacewalkproject/spacewalk-2.10/epel-7-x86_64/repodata/repomd.xml --nogpg

# SELinux in enforced mode
sestatus

# Additional repos & packages
# Spacewalk requires a Java Virtual Machine with version 1.6.0 or greater.
# EPEL 7 (use for Red Hat Enterprise Linux 7, Scientific Linux 7, CentOS 7)
rpm -Uvh https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm

# Database server
# Spacewalk uses database server to store its primary data. 
# PostgreSQL server, set up by Spacewalk (embedded)
yum -yq install spacewalk-setup-postgresql
yum -yq install spacewalk-postgresql 

#  Enable Firewalld
 systemctl enable firewalld
 systemctl restart firewalld

# Configuring the firewall
# Use system-config-firewall or 
# edit /etc/sysconfig/iptables, adding the ports needed -- 80 and 443.
# Add port 5222 if you want to push actions to client machines 
# and 5269 for push actions to a Spacewalk Proxy, 
# 69 udp if you want to use tftp

firewall-cmd --add-service=http
firewall-cmd --add-service=https
firewall-cmd --runtime-to-perm

#  reload the firewall.
 firewall-cmd --reload
#  Enable Firewalld
#  systemctl enable firewalld
 systemctl restart firewalld

# # Configuring Spacewalk with an Answer File
# spacewalk-setup --answer-file=/vagrant/configs/answers-PostgreSQL

# # Managing Spacewalk
# /usr/sbin/spacewalk-service start

# curl http://192.168.1.20

# yum whatprovides */netstat
# yum install -qy net-tools

# # Check the logstash service  port '5443'.
# netstat -plntu