#!/bin/bash

set -e

VERSION_GENERATOR=""
VERSION_FORMATTER=""
NAMESPACE="timestamp"

for arg in "$@"; do
    case $arg in
        --version_generator=*) VERSION_GENERATOR="${arg#*=}" ;;
        --version_formatter=*) VERSION_FORMATTER="${arg#*=}" ;;
        --namespace=*) NAMESPACE="${arg#*=}" ;;
        *) echo "Unknown argument: $arg"; exit 1 ;;
    esac
done

echo "Deploying:"
echo "  timestamp-generator: ${VERSION_GENERATOR:-latest}"
echo "  timestamp-formatter: ${VERSION_FORMATTER:-latest}"
echo "  namespace: ${NAMESPACE}"

k8s kubectl apply -f namespace.yaml -f resourcequota.yaml

GENERATOR_ARGS=""
FORMATTER_ARGS=""
[[ -n "${VERSION_GENERATOR}" ]] && GENERATOR_ARGS="--set image.tag=${VERSION_GENERATOR}"
[[ -n "${VERSION_FORMATTER}" ]] && FORMATTER_ARGS="--set image.tag=${VERSION_FORMATTER}"

helm upgrade --install timestamp-generator ./helm/timestamp-generator --namespace "${NAMESPACE}" ${GENERATOR_ARGS}
helm upgrade --install timestamp-formatter ./helm/timestamp-formatter --namespace "${NAMESPACE}" ${FORMATTER_ARGS}

k8s kubectl rollout status deployment/timestamp-generator -n "${NAMESPACE}"
k8s kubectl rollout status deployment/timestamp-formatter -n "${NAMESPACE}"

echo "Done."
