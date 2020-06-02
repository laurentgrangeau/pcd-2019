#!/bin/bash

INSTANCES_ID=$(aws ec2 describe-instances --output text --query 'Reservations[*].Instances[*].[InstanceId]' --filter 'Name=instance-state-name,Values=running')
PUBLIC_IP=$(aws ec2 describe-instances --filters 'Name=tag:Name,Values=controller-0' 'Name=instance-state-name,Values=running' --output text --query 'Reservations[*].Instances[*].[PublicIpAddress]')

for id in $INSTANCES_ID
do
  NAME=$(aws ec2 describe-instances --output text --instance-ids $id --query 'Reservations[*].Instances[*].[Tags[?Key==`Name`].Value]')
  if [[ $NAME == *"worker"* ]]; then
    kubectl config set-cluster kubernetes-the-hard-way --certificate-authority=ca.pem --embed-certs=true --server=https://${PUBLIC_IP}:6443 --kubeconfig=${id}.kubeconfig
    kubectl config set-credentials system:node:${id} --client-certificate=${id}.pem --client-key=${id}-key.pem --embed-certs=true --kubeconfig=${id}.kubeconfig
    kubectl config set-context default --cluster=kubernetes-the-hard-way --user=system:node:${id} --kubeconfig=${id}.kubeconfig
    kubectl config use-context default --kubeconfig=${id}.kubeconfig
  fi
done

kubectl config set-cluster kubernetes-the-hard-way --certificate-authority=ca.pem --embed-certs=true --server=https://${PUBLIC_IP}:6443 --kubeconfig=kube-proxy.kubeconfig
kubectl config set-credentials system:kube-proxy --client-certificate=kube-proxy.pem --client-key=kube-proxy-key.pem --embed-certs=true --kubeconfig=kube-proxy.kubeconfig
kubectl config set-context default --cluster=kubernetes-the-hard-way --user=system:kube-proxy --kubeconfig=kube-proxy.kubeconfig
kubectl config use-context default --kubeconfig=kube-proxy.kubeconfig

kubectl config set-cluster kubernetes-the-hard-way --certificate-authority=ca.pem --embed-certs=true --server=https://127.0.0.1:6443 --kubeconfig=kube-controller-manager.kubeconfig
kubectl config set-credentials system:kube-controller-manager --client-certificate=kube-controller-manager.pem --client-key=kube-controller-manager-key.pem --embed-certs=true --kubeconfig=kube-controller-manager.kubeconfig
kubectl config set-context default --cluster=kubernetes-the-hard-way --user=system:kube-controller-manager --kubeconfig=kube-controller-manager.kubeconfig
kubectl config use-context default --kubeconfig=kube-controller-manager.kubeconfig

kubectl config set-cluster kubernetes-the-hard-way --certificate-authority=ca.pem --embed-certs=true --server=https://127.0.0.1:6443 --kubeconfig=kube-scheduler.kubeconfig
kubectl config set-credentials system:kube-scheduler --client-certificate=kube-scheduler.pem --client-key=kube-scheduler-key.pem --embed-certs=true --kubeconfig=kube-scheduler.kubeconfig
kubectl config set-context default --cluster=kubernetes-the-hard-way --user=system:kube-scheduler --kubeconfig=kube-scheduler.kubeconfig
kubectl config use-context default --kubeconfig=kube-scheduler.kubeconfig

kubectl config set-cluster kubernetes-the-hard-way --certificate-authority=ca.pem --embed-certs=true --server=https://127.0.0.1:6443 --kubeconfig=admin.kubeconfig
kubectl config set-credentials admin --client-certificate=admin.pem --client-key=admin-key.pem --embed-certs=true --kubeconfig=admin.kubeconfig
kubectl config set-context default --cluster=kubernetes-the-hard-way --user=admin --kubeconfig=admin.kubeconfig
kubectl config use-context default --kubeconfig=admin.kubeconfig