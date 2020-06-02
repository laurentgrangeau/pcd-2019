#!/bin/bash

cd ~/scripts/

INTERNAL_IP=$(curl http://169.254.169.254/latest/meta-data/local-ipv4)

sudo mkdir -p /var/lib/kubernetes/
sudo cp ca.pem ca-key.pem kubernetes-key.pem kubernetes.pem service-account-key.pem service-account.pem /var/lib/kubernetes/
sudo cp ../encryption/encryption-config.yml /var/lib/kubernetes/

sudo cp ../systemd/kube-apiserver.service /etc/systemd/system/kube-apiserver.service
sudo sed -i -e 's/${INTERNALIP}/'${INTERNAL_IP}'/g' /etc/systemd/system/kube-apiserver.service

sudo cp ../systemd/kube-controller-manager.service /etc/systemd/system/kube-controller-manager.service
sudo cp kube-controller-manager.kubeconfig /var/lib/kubernetes/

sudo mkdir -p /etc/kubernetes/config/
sudo cp ../config/kube-scheduler.yml /etc/kubernetes/config/kube-scheduler.yml
sudo cp ../systemd/kube-scheduler.service /etc/systemd/system/kube-scheduler.service
sudo cp kube-scheduler.kubeconfig /var/lib/kubernetes/

sudo systemctl daemon-reload
sudo systemctl enable kube-apiserver kube-controller-manager kube-scheduler
sudo systemctl start kube-apiserver kube-controller-manager kube-scheduler

sleep 10

kubectl apply --kubeconfig admin.kubeconfig -f ../config/rbac.yml