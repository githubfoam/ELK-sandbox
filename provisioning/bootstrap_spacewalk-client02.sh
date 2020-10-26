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
echo "================================== Spacewalk Client Configuration ======================================================="

rpm -Uvh http://yum.spacewalkproject.org/2.6-client/RHEL/7/x86_64/spacewalk-client-repo-2.6-0.el7.noarch.rpm

# Enable epel repo
yum install epel-release -y  
yum install rhn-client-tools rhn-check rhn-setup rhnsd m2crypto yum-rhn-plugin osad rhncfg-actions rhncfg-management -y

# download the ssl certificate from spacewalk server
wget -O /usr/share/rhn/RHN-ORG-TRUSTED-SSL-CERT http://spacewalk-server.local/pub/RHN-ORG-TRUSTED-SSL-CERT

# register with the activation key 
rhnreg_ks --force --activationkey="1-centos7" --serverUrl=http://spacewalk.sunil.cc/XMLRPC --sslCACert=/usr/share/rhn/RHN-ORG-TRUSTED-SSL-CERT --profilename=$HOSTNAME

Syncing the profile with spacewalk
rhn-profile-sync

systemctl enable osad
systemctl restart osad
systemctl status osad
rhn-actions-control --enable-all

# do a profile sync
rhn-profile-sync
