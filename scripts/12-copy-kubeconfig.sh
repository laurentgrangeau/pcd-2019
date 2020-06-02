#!/bin/bash
for controller in 10.240.0.11 10.240.0.12;
do
  scp -oStrictHostKeyChecking=no admin.kubeconfig kube-controller-manager.kubeconfig kube-scheduler.kubeconfig ubuntu@${controller}:~/scripts/
done

INSTANCES_ID=$(aws ec2 describe-instances --output text --query 'Reservations[*].Instances[*].[InstanceId]' --filter 'Name=instance-state-name,Values=running')

for id in $INSTANCES_ID
do
  NAME=$(aws ec2 describe-instances --output text --instance-ids $id --query 'Reservations[*].Instances[*].[Tags[?Key==`Name`].Value]')
  if [[ $NAME == *"worker"* ]]; then
    INTERNAL_IP=$(aws ec2 describe-instances --output text --instance-ids $id --query 'Reservations[*].Instances[*].[PrivateIpAddress]')
    scp -oStrictHostKeyChecking=no ${id}.kubeconfig kube-proxy.kubeconfig ubuntu@${INTERNAL_IP}:~/
  fi
done