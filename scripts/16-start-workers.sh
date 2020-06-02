#!/bin/bash

for worker in 10.240.0.20 10.240.0.21 10.240.0.22;
do
  scp -oStrictHostKeyChecking=no -rp ../systemd/ ubuntu@${worker}:~/systemd/
  scp -oStrictHostKeyChecking=no -rp ../config/ ubuntu@${worker}:~/config/
  scp -oStrictHostKeyChecking=no 22-bootstrap-workers.sh ubuntu@${worker}:~/scripts/
  ssh -oStrictHostKeyChecking=no ubuntu@${worker} '~/scripts/22-bootstrap-workers.sh'
done