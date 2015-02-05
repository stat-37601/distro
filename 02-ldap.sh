#!/bin/bash -ex
#
# This script adds support for LDAP logins to the root server.
#

sudo apt-get ldap-auth-client nscd
sudo auth-ldap-client -t nss -p lac_ldap

cat >> /usr/share/pam-configs/my_mkhomedir <<EOF
Name: activate mkhomedir
Default: yes
Priority: 900
Session-Type: Additional
Session:
        required                        pam_mkhomedir.so umask=0022 skel=/etc/skel
EOF