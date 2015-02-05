#!/bin/bash -ex
#
# This script adds the stat-37601 S3 bucket to /s3/stat-37601.
#

if ! which s3fs; then

  # Fetch dependencies.
  if which apt-get; then # Ubuntu Linux.
    sudo apt-get install -y build-essential git libfuse-dev libcurl4-openssl-dev \
                            libxml2-dev mime-support automake libtool pkg-config \
                            libssl-dev
  else # Amazon/Red Hat/CentOS Linux.
    sudo yum install -y gcc libstdc++-devel gcc-c++ fuse fuse-devel curl-devel \
                        libxml2-devel mailcap automake openssl-devel mailcap
  fi

  # Download and install S3Fuse.
  git clone https://github.com/s3fs-fuse/s3fs-fuse /tmp/s3fs-fuse
  cd /tmp/s3fs-fuse
  ./autogen.sh
  ./configure --prefix=/usr --with-openssl
  make
  sudo make install
fi

# Mount data from S3 into /s3.
sudo mkdir -p /s3/stat-37601
sudo s3fs -o public_bucket=1 -o allow_other stat-37601 /s3/stat-37601