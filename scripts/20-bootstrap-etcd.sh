#!/bin/bash

cd ~/scripts/

INTERNAL_IP=$(curl http://169.254.169.254/latest/meta-data/local-ipv4)
INSTANCE_ID=$(curl http://169.254.169.254/latest/meta-data/instance-id)
ETCD_NAME=$(aws ec2 describe-instances --output text --instance-ids $INSTANCE_ID --query 'Reservations[*].Instances[*].[Tags[?Key==`Name`].Value]')

sudo mkdir /etc/etcd
sudo cp ca.pem kubernetes-key.pem kubernetes.pem /etc/etcd/

sudo cp ../systemd/etcd.service /etc/systemd/system/etcd.service

sudo sed -i -e 's/${ETCDNAME}/'${ETCD_NAME}'/g' /etc/systemd/system/etcd.service
sudo sed -i -e 's/${INTERNALIP}/'${INTERNAL_IP}'/g' /etc/systemd/system/etcd.service

sudo systemctl daemon-reload
sudo systemctl enable etcd
sudo systemctl start etcd