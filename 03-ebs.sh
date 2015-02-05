#!/bin/bash -ex
#
# This script adds support for the EBS mount at /home.
# 
# It is expected that /dev/sdb is already formatted as a ext3 volume.
#

# Configure /dev/sdb as an ext3 volume.
sudo sed -i ':/dev/sdb:d' /etc/fstab

sudo tee -a /etc/fstab <<EOF
/dev/sdb	/home	ext3	defaults	0 0
EOF

# Mount the volume as /home.
if mount | grep -v /dev/sdb; then
	sudo mount -a
fi