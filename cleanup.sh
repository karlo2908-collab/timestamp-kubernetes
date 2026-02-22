#!/bin/bash

set -e

NAMESPACE="timestamp"

echo "Uninstalling Helm releases..."
helm uninstall timestamp-generator timestamp-formatter -n "${NAMESPACE}" 2>/dev/null || true

echo "Deleting namespace..."
kubectl delete namespace "${NAMESPACE}" 2>/dev/null || true

echo "Done."
