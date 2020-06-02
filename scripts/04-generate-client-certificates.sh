#!/bin/bash
INSTANCES_ID=$(aws ec2 describe-instances --output text --query 'Reservations[*].Instances[*].[InstanceId]' --filter 'Name=instance-state-name,Values=running')

for id in $INSTANCES_ID
do
  NAME=$(aws ec2 describe-instances --output text --instance-ids $id --query 'Reservations[*].Instances[*].[Tags[?Key==`Name`].Value]')
  if [[ $NAME == *"worker"* ]]; then
    EXTERNAL_IP=$(aws ec2 describe-instances --output text --instance-ids $id --query 'Reservations[*].Instances[*].[PublicIpAddress]')
    INTERNAL_IP=$(aws ec2 describe-instances --output text --instance-ids $id --query 'Reservations[*].Instances[*].[PrivateIpAddress]')
    HOSTNAME=$(aws ec2 describe-instances --output text --instance-ids $id --query 'Reservations[*].Instances[*].[PrivateDnsName]' | cut -d'.' -f1)
    cp ../ca/instances-csr.json ../ca/${id}-csr.json
    sed -i -e 's/${instance}/'${HOSTNAME}'/g' ../ca/${id}-csr.json
    cfssl gencert -ca=ca.pem -ca-key=ca-key.pem -config=../ca/ca-config.json -hostname=${HOSTNAME},${EXTERNAL_IP},${INTERNAL_IP} -profile=kubernetes ../ca/${id}-csr.json | cfssljson -bare ${id}
  fi
done