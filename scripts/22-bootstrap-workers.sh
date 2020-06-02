#!/bin/bash

cd ~/scripts/

INSTANCE_ID=$(curl http://169.254.169.254/latest/meta-data/instance-id)

sudo mkdir -p /etc/cni/net.d /opt/cni/bin /var/lib/kubelet /var/lib/kube-proxy /var/lib/kubernetes /var/run/kubernetes /etc/containerd/

wget -q --show-progress --https-only --timestamping https://github.com/containernetworking/plugins/releases/download/v0.6.0/cni-plugins-amd64-v0.6.0.tgz
sudo tar -xvf cni-plugins-amd64-v0.6.0.tgz -C /opt/cni/bin/

sudo cp ../config/10-bridge.conf /etc/cni/net.d/10-bridge.conf
sudo cp ../config/99-loopback.conf /etc/cni/net.d/99-loopback.conf
sudo cp ../config/config.toml /etc/containerd/config.toml
sudo cp ../systemd/containerd.service /etc/systemd/system/containerd.service

sudo cp ${INSTANCE_ID}-key.pem ${INSTANCE_ID}.pem /var/lib/kubelet/
sudo cp ../${INSTANCE_ID}.kubeconfig /var/lib/kubelet/kubeconfig
sudo cp ca.pem /var/lib/kubernetes/

sudo cp ../config/kubelet-config.yml /var/lib/kubelet/kubelet-config.yml
sudo sed -i -e 's/${HOSTNAME}/'${INSTANCE_ID}'/g' /var/lib/kubelet/kubelet-config.yml
sudo cp ../systemd/kubelet.service /etc/systemd/system/kubelet.service

sudo cp ../kube-proxy.kubeconfig /var/lib/kube-proxy/kubeconfig
sudo cp ../config/kube-proxy-config.yml /var/lib/kube-proxy/kube-proxy-config.yml
sudo cp ../systemd/kube-proxy.service /etc/systemd/system/kube-proxy.service

sudo systemctl daemon-reload
sudo systemctl enable containerd kubelet kube-proxy
sudo systemctl start containerd kubelet kube-proxy