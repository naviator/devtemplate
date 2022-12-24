# Local development environment

## Setup

An easy way to start developing is using a local [minikube](https://minikube.sigs.k8s.io) cluster. Example:
```
minikube start --driver=qemu2 --container-runtime=containerd --cpus=6 --memory=10g --disk-size=100g
```
Of course, you might prefer other ways to develop locally.

## Local registry

Some ways to use locally built images:
- [minikube registry addon](https://minikube.sigs.k8s.io/docs/handbook/registry/)
- `sh local/registry/generate_tls.sh && kubectl apply -f local/registry/registry.yaml` (currently not working on Minikube)

## Backup

Backup of volumes is available via a sidecar. Backup considers folders specified in annotation `naviator.github.io/devtemplate-backup-folders` (colon separated). After time specified in annotation `naviator.github.io/devtemplate-backup-interval`, folders are backed up and restored via `initContainer` every N minutes. Example:
```
metadata:
  annotations:
    naviator.github.io/devtemplate-backup-folders: "/data:/workspace"
    naviator.github.io/devtemplate-backup-interval: "10m"
```
