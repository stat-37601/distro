#!/bin/bash -ex
# IPython Spark copier
#
# Author: Jeremy Archer (open-source@fatlotus.com)
# Date: 12 February 2015

# Change the next line ->             vvvvvv
export BACKUP_BUCKET="s3://stat-37601-CNETID"
#                                     ^^^^^^

# Install prerequisites.
sudo yum -y install python27 python27-pip python27-devel aws-cli
sudo pip-2.7 install -U ipython pyzmq jinja2 tornado backports.ssl_match_hostname jsonschema
touch /usr/lib/python2.7/site-packages/backports/__init__.py

# Wait until configured.
while [ ! -f ./spark-ec2/ec2-variables.sh ]; do
  sleep 5
done

# Set up local environment variables.
. ./spark-ec2/ec2-variables.sh

export PYSPARK_PYTHON="$(which python27)"
export IPYTHON_OPTS="notebook --ip=0.0.0.0 --port=8081"
export MASTER="spark://0.0.0.0:8081"

# Ensure that we are the master instance.
export MY_ADDRESS=$(curl http://169.254.169.254/latest/meta-data/public-hostname)

if [ "$MY_ADDRESS" != "$MASTERS" ]; then
  exit 1
fi

# Prepare notebook copier to S3.
mkdir -p notebooks/
cd notebooks/

updater(){
  aws s3 sync $BACKUP_BUCKET .
  while nc -w 1 127.0.0.1 8081; do
    aws s3 sync --exclude ".*" . $BACKUP_BUCKET || true
    sleep 10
  done
}

updater &

# Run IPython + PySpark.
../spark/bin/pyspark &
