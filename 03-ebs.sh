#!/bin/bash -ex
#
# This script adds support for the EBS mount at /home.
# 
# It is expected that /dev/xvdb is already formatted as a ext3 volume.
#

# Configure /dev/xvdb as an ext3 volume.
sudo sed -i ':/dev/xvdb:d' /etc/fstab

sudo tee -a /etc/fstab <<EOF
/dev/xvdb	/home	ext3	defaults	0 0
EOF

# Mount the volume as /home.
if mount | grep /dev/xvdb; then
	# Already set up!
else
	sudo mount -a
fi