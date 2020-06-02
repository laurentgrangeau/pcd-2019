#!/bin/bash

./21-bootstrap-control-plane.sh

for controller in 10.240.0.11 10.240.0.12;
do
  ssh -oStrictHostKeyChecking=no ubuntu@${controller} 'mkdir ~/config/'
  ssh -oStrictHostKeyChecking=no ubuntu@${controller} 'mkdir ~/encryption/'
  scp -oStrictHostKeyChecking=no ../systemd/kube-apiserver.service ubuntu@${controller}:~/systemd/
  scp -oStrictHostKeyChecking=no ../systemd/kube-controller-manager.service ubuntu@${controller}:~/systemd/
  scp -oStrictHostKeyChecking=no ../systemd/kube-scheduler.service ubuntu@${controller}:~/systemd/
  scp -oStrictHostKeyChecking=no ../config/kube-scheduler.yml ubuntu@${controller}:~/config/
  scp -oStrictHostKeyChecking=no ../config/rbac.yml ubuntu@${controller}:~/config/
  scp -oStrictHostKeyChecking=no kube-controller-manager.kubeconfig ubuntu@${controller}:~/scripts/
  scp -oStrictHostKeyChecking=no kube-scheduler.kubeconfig ubuntu@${controller}:~/scripts/
  scp -oStrictHostKeyChecking=no 21-bootstrap-control-plane.sh ubuntu@${controller}:~/scripts/
  scp -oStrictHostKeyChecking=no ../encryption/encryption-config.yml ubuntu@${controller}:~/encryption/
  ssh -oStrictHostKeyChecking=no ubuntu@${controller} '~/scripts/21-bootstrap-control-plane.sh'
done
