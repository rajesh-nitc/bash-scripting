#!/bin/bash

openssl genrsa -out rajesh.key 2048
openssl req -new -key rajesh.key -out rajesh.csr -subj "/CN=rajesh/O=devops"
cat rajesh.csr | base64 | tr -d "\n"
CSR_BASE64=$(cat rajesh.csr | base64 | tr -d "\n")

cat <<EOF | kubectl apply -f -
apiVersion: certificates.k8s.io/v1beta1
kind: CertificateSigningRequest
metadata:
  name: john
spec:
  groups:
  - system:authenticated
  request: $CSR_BASE64
  usages:
  - client auth
EOF

# https://kubernetes.io/docs/reference/access-authn-authz/certificate-signing-requests/#normal-user