#!/bin/bash
KUBERNETES_PUBLIC_ADDRESS=$(curl http://169.254.169.254/latest/meta-data/public-ipv4)
cfssl gencert -ca=ca.pem -ca-key=ca-key.pem -config=../ca/ca-config.json -hostname=10.32.0.1,10.240.0.10,10.240.0.11,10.240.0.12,${KUBERNETES_PUBLIC_ADDRESS},127.0.0.1,kubernetes.default -profile=kubernetes ../ca/kubernetes-csr.json | cfssljson -bare kubernetes