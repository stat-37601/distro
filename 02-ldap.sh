#!/bin/bash -ex
#
# This script adds support for LDAP logins to the root server.
#

sudo apt-get -y install ldap-auth-client nscd
sudo auth-client-config -t nss -p lac_ldap

# Configure nsswitch.
sudo tee /usr/share/pam-configs/my_mkhomedir > /dev/null <<EOF
Name: activate mkhomedir
Default: yes
Priority: 900
Session-Type: Additional
Session:
        required                        pam_mkhomedir.so umask=0022 skel=/etc/skel
EOF

# Remap attributes for users.
sudo sed -i '/LSDASETUP/d' /etc/ldap.conf
sudo tee /etc/lib.conf > /dev/null <<EOF
uid nslcd
gid nslcd
uri ldap://ldap.uchicago.edu
base dc=uchicago,dc=edu
ssl start_tls
tls_reqcert never
map passwd loginShell "/bin/bash"
map passwd homeDirectory "/home/$uid"
EOF

sudo /etc/init.d/nscd restart

# Update SSH to allow remote student logins.
sudo sed -i '/LSDASETUP/d' /etc/ssh/sshd_config
sudo tee -a /etc/ssh/sshd_config > /dev/null <<EOF
Match User jarcher,lafferty,vvora,yjchoe # LSDASETUP
    PasswordAuthentication yes # LSDASETUP
EOF

sudo /etc/init.d/ssh restart