#!/bin/bash

set -e

NAMESPACE="timestamp"

echo "Deleting deployments..."
kubectl delete deployment timestamp-generator timestamp-formatter -n "${NAMESPACE}" 2>/dev/null || true

echo "Deleting services..."
kubectl delete service timestamp-generator timestamp-formatter -n "${NAMESPACE}" 2>/dev/null || true

echo "Deleting network policies..."
kubectl delete networkpolicy timestamp-generator timestamp-formatter -n "${NAMESPACE}" 2>/dev/null || true

echo "Deleting namespace..."
kubectl delete namespace "${NAMESPACE}" 2>/dev/null || true

echo "Done."
