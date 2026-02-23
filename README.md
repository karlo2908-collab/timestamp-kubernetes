# Timestamp-kubernetes

This repo contains kubernetes related files and scripts for the repositories `timestamp-generator` and `timestamp-formatter`.

## Prerequisites

- kubectl
- Helm
- Python 3.x
- `requests` (`pip install requests`)

## Basic kubernetes

Basic kubernetes `.yaml` files are contained in `formatter` and `generator` directories.

Directories hold deployment, networkpolicy and service files needed for the deployment.

Production use of these repositories would at least change several variables from these files:
1. Replicas → would use more than 1 to ensure no/minimal downtime of the services
2. NodePort → system would use some kind of gateway either provided by the cloud provider of self-hosted

In the root directory, there are namespace and resourcequota files related to this deployment.

Following simple scripts ensure startup and cleanup of kubernetes build:

```bash 
./deploy-kube.sh
./cleanup-kube.sh
```

You can start both of the services with kubectl commands as follows:

```bash 
kubectl apply -f namespace.yaml -f resourcequota.yaml
kubectl apply -f generator/ -f formatter/
```

## Kubernetes with helm

Helm files alongside with templates are provided in `helm/` directory.

Following simple scripts ensure startup and cleanup of kubernetes-helm build:

```bash 
./deploy.sh
./cleanup.sh
```

After running deployment scripts pods are rolled out:

```bash
root@kube:/opt/actions-runner/_work/timestamp-kubernetes/timestamp-kubernetes# bash deploy.sh
Deploying:
  timestamp-generator:
  timestamp-formatter:
  namespace: timestamp
namespace/timestamp unchanged
resourcequota/timestamp-quota unchanged
Release "timestamp-generator" has been upgraded. Happy Helming!
NAME: timestamp-generator
LAST DEPLOYED: Mon Feb 23 18:35:18 2026
NAMESPACE: timestamp
STATUS: deployed
REVISION: 13
DESCRIPTION: Upgrade complete
TEST SUITE: None
Release "timestamp-formatter" has been upgraded. Happy Helming!
NAME: timestamp-formatter
LAST DEPLOYED: Mon Feb 23 18:35:18 2026
NAMESPACE: timestamp
STATUS: deployed
REVISION: 13
DESCRIPTION: Upgrade complete
TEST SUITE: None
deployment "timestamp-generator" successfully rolled out
deployment "timestamp-formatter" successfully rolled out
Done.
root@kube:/opt/actions-runner/_work/timestamp-kubernetes/timestamp-kubernetes# kubectl get pods -n timestamp
NAME                                   READY   STATUS    RESTARTS   AGE
timestamp-formatter-5f7b8d489c-mxc2c   1/1     Running   0          27h
timestamp-generator-7dc9f9bb9-nhkwh    1/1     Running   0          27h
root@kube:/opt/actions-runner/_work/timestamp-kubernetes/timestamp-kubernetes#
```

After cleanup:

```bash
root@kube:/opt/actions-runner/_work/timestamp-kubernetes/timestamp-kubernetes# bash cleanup.sh
Uninstalling Helm releases...
release "timestamp-generator" uninstalled
release "timestamp-formatter" uninstalled
Deleting namespace...
namespace "timestamp" deleted
Done.
root@kube:/opt/actions-runner/_work/timestamp-kubernetes/timestamp-kubernetes# kubectl get pods -n timestamp
No resources found in timestamp namespace.
root@kube:/opt/actions-runner/_work/timestamp-kubernetes/timestamp-kubernetes#
```

### `deploy.sh` usage

```bash
bash deploy.sh [OPTIONS]
```

#### Options

| Option | Default | Description            |
|--------|---------|------------------------|
| `--version_generator` | `latest` | Generator image version |
| `--version_formatter` | `latest` | Formatter image version |
| `--namespace` | `timestamp` | Kubernetes namespace   |

#### Examples

```bash
# Deploy with defaults
bash deploy.sh

# Deploy specific versions
bash deploy.sh --version_generator=sha-abc1234 --version_formatter=sha-abc1234

# Custom namespace
bash deploy.sh --namespace=staging
```

### Manually running images

You can start both of the services with a mix of `kubectl` and `helm` commands:

```bash
helm upgrade --install timestamp-generator ./helm/timestamp-generator 
helm upgrade --install timestamp-formatter ./helm/timestamp-formatter 
```


## CD pipeline

Similarly to `timestamp-deployment` repo, this repository contains CD pipeline for running and upgrading the pods.
Pipeline also runs tests and are mixed here with the deploy step just to show them. Real integration tests would, in production setup, be run on different runner that serves just for testing and that run would be prerequisite for the actual deploy step. 

Since this deployment is done on only 1 node, the test script uses `localhost` address. In multinode setup this would have to be changed.
