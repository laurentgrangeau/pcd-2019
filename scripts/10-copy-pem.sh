#!/bin/bash

for controller in 10.240.0.11 10.240.0.12;
do
  scp -oStrictHostKeyChecking=no ca.pem ca-key.pem kubernetes-key.pem kubernetes.pem service-account-key.pem service-account.pem ubuntu@${controller}:~/scripts/
done

INSTANCES_ID=$(aws ec2 describe-instances --output text --query 'Reservations[*].Instances[*].[InstanceId]' --filter 'Name=instance-state-name,Values=running')

for id in $INSTANCES_ID
do
  NAME=$(aws ec2 describe-instances --output text --instance-ids $id --query 'Reservations[*].Instances[*].[Tags[?Key==`Name`].Value]')
  if [[ $NAME == *"worker"* ]]; then
    INTERNAL_IP=$(aws ec2 describe-instances --output text --instance-ids $id --query 'Reservations[*].Instances[*].[PrivateIpAddress]')
    ssh -oStrictHostKeyChecking=no ubuntu@${INTERNAL_IP} 'mkdir ~/scripts/'
    scp -oStrictHostKeyChecking=no ca.pem ${id}-key.pem ${id}.pem ubuntu@${INTERNAL_IP}:~/scripts/
  fi
done