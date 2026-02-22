#!/bin/bash

set -e

kubectl delete -f generator/ -f formatter/ 2>/dev/null || true
kubectl delete namespace timestamp 2>/dev/null || true

echo "Done."
