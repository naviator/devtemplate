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

Backup of volumes is provided through a sidecar. Backup considers `folders` specified in annotation (colon separated). After `delay` specified in annotation, folders are backed up and restored via `initContainer` every `interval`. Time values must be `sleep` command compatible. Example:
```
metadata:
  annotations:
    devtemplate.naviator.github.io/backup-folders: "/data:/workspace"
    devtemplate.naviator.github.io/backup-delay: "10m"
    devtemplate.naviator.github.io/backup-interval: "5m"
```
