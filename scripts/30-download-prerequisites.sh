#!/bin/bash

DEBIAN_FRONTEND=noninteractive sudo apt -y update && sudo apt -y full-upgrade && sudo apt -y install golang-cfssl awscli
curl -L https://github.com/etcd-io/etcd/releases/download/v3.3.10/etcd-v3.3.10-linux-amd64.tar.gz | tar --strip-components=1 --wildcards -zx '*/etcd' '*/etcdctl'
curl -L https://dl.k8s.io/v1.13.0/kubernetes-server-linux-amd64.tar.gz | tar --strip-components=3 -zx kubernetes/server/bin/hyperkube

## Copy hyperkube components in $PATH
for BINARY in hyperkube;
do
  sudo mv $BINARY /usr/local/sbin/
done

## Copy etcd components in $PATH
for BINARY in etcd etcdctl;
do
  sudo mv $BINARY /usr/local/sbin/
done

cd /usr/local/sbin

for BINARY in kubectl kube-apiserver kube-scheduler kube-controller-manager kubelet kube-proxy;
do
  sudo ln -s hyperkube $BINARY
done