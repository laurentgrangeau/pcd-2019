#!/bin/bash
cfssl gencert -ca=ca.pem -ca-key=ca-key.pem -config=../ca/ca-config.json -profile=kubernetes ../ca/kube-controller-manager-csr.json | cfssljson -bare kube-controller-manager