#!/bin/bash

./20-bootstrap-etcd.sh

for controller in 10.240.0.11 10.240.0.12;
do
  ssh -oStrictHostKeyChecking=no ubuntu@${controller} 'mkdir ~/systemd/'
  scp -oStrictHostKeyChecking=no ../systemd/etcd.service ubuntu@${controller}:~/systemd/
  scp -oStrictHostKeyChecking=no 20-bootstrap-etcd.sh ubuntu@${controller}:~/scripts/
  ssh -oStrictHostKeyChecking=no ubuntu@${controller} '~/scripts/20-bootstrap-etcd.sh'
done
