#!/bin/bash

DEBIAN_FRONTEND=noninteractive sudo apt -y update && sudo apt -y full-upgrade && sudo apt -y install socat conntrack ipset
curl -L https://dl.k8s.io/v1.13.0/kubernetes-server-linux-amd64.tar.gz | tar --strip-components=3 -zx kubernetes/server/bin/hyperkube
curl -L https://download.docker.com/linux/static/stable/x86_64/docker-18.09.0.tgz | tar --strip-components=1 -zx

## Copy docker components in $PATH
for BINARY in dockerd containerd containerd-shim runc docker docker-init docker-proxy ctr;
do
  sudo mv $BINARY /usr/local/sbin/
done

## Copy hyperkube components in $PATH
for BINARY in hyperkube;
do
  sudo mv $BINARY /usr/local/sbin/
done

cd /usr/local/sbin

for BINARY in kubectl kube-apiserver kube-scheduler kube-controller-manager kubelet kube-proxy;
do
  sudo ln -s hyperkube $BINARY
done