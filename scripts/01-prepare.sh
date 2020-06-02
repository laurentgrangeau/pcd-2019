#!/bin/bash

./30-download-prerequisites.sh

for controller in 10.240.0.11 10.240.0.12;
do
  ssh -oStrictHostKeyChecking=no ubuntu@${controller} 'mkdir ~/scripts/'
  scp -oStrictHostKeyChecking=no 30-download-prerequisites.sh ubuntu@${controller}:~/scripts/
  ssh -oStrictHostKeyChecking=no ubuntu@${controller} '~/scripts/30-download-prerequisites.sh'
  scp -rp -oStrictHostKeyChecking=no ../.aws/ ubuntu@${controller}:~/.aws/
done

for worker in 10.240.0.20 10.240.0.21 10.240.0.22;
do
  ssh -oStrictHostKeyChecking=no ubuntu@${worker} 'mkdir ~/scripts/'
  scp -oStrictHostKeyChecking=no 31-download-prerequisites-worker.sh ubuntu@${worker}:~/scripts/
  ssh -oStrictHostKeyChecking=no ubuntu@${worker} '~/scripts/31-download-prerequisites-worker.sh'
done