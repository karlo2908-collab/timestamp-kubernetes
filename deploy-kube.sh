#!/bin/bash

set -e

kubectl apply -f namespace.yaml -f resourcequota.yaml
kubectl apply -f generator/ -f formatter/

kubectl rollout status deployment/timestamp-generator -n timestamp
kubectl rollout status deployment/timestamp-formatter -n timestamp

echo "Done."
