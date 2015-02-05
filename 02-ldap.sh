#!/bin/bash -ex
#
# This script adds support for LDAP logins to the root server.
#

sudo apt-get -y install ldap-auth-client nscd
sudo auth-client-config -t nss -p lac_ldap

cat > /usr/share/pam-configs/my_mkhomedir <<EOF
Name: activate mkhomedir
Default: yes
Priority: 900
Session-Type: Additional
Session:
        required                        pam_mkhomedir.so umask=0022 skel=/etc/skel
EOF

sudo /etc/init.d/nscd restart

sudo sed -i '/LSDASETUP/d' /etc/ssh/sshd_config

sudo cat >> /etc/ssh/sshd_config <<EOF
Match User jarcher,lafferty,vvora,yjchoe # LSDASETUP
    PasswordAuthentication no # LSDASETUP
EOF