#!/bin/bash

ENCRYPTION_KEY=$(head -c 32 /dev/urandom | base64)

sed -i -e 's@${ENCRYPTIONKEY}@'${ENCRYPTION_KEY}'@g' ../encryption/encryption-config.yml

for controller in 10.240.0.11 10.240.0.12;
do
  scp -oStrictHostKeyChecking=no ../encryption/encryption-config.yml ubuntu@${controller}:~/
done
