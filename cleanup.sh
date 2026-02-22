#!/bin/bash

set -e

NAMESPACE="timestamp"

echo "Deleting deployments..."
k8s kubectl delete deployment timestamp-generator timestamp-formatter -n "${NAMESPACE}" 2>/dev/null || true

echo "Deleting services..."
k8s kubectl delete service timestamp-generator timestamp-formatter -n "${NAMESPACE}" 2>/dev/null || true

echo "Deleting network policies..."
k8s kubectl delete networkpolicy timestamp-generator timestamp-formatter -n "${NAMESPACE}" 2>/dev/null || true

echo "Deleting namespace..."
k8s kubectl delete namespace "${NAMESPACE}" 2>/dev/null || true

echo "Done."
