#!/bin/bash
cfssl gencert -ca=ca.pem -ca-key=ca-key.pem -config=../ca/ca-config.json -profile=kubernetes ../ca/admin-csr.json | cfssljson -bare admin