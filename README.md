# Local development environment

## Setup

### Mac OS X

Create lima-vm machine using included config file:
```
limactl start machine/default.yaml
```

Copy KUBECONFIG file:
```
limactl shell default sudo cat /etc/rancher/k3s/k3s.yaml > ~/.kube/lima-config
sed -i '' 's/ default/ lima/g' ~/.kube/lima-config
```

## Persistence

```
kubectl apply -f kube/01_persistence.yaml
```

## Install local registry

Installing registry allows to build development images on localhost.
Generate new TLS secret using `kube/registry/generate_tls.sh`.

```
kubectl apply -f kube/registry
```

## Syncing with localhost

Sync remote container folder with local folder with `rsync`. Example:
```
./sync.sh -ra go:/workspace/ workspace/
```
`rsync` needs to be installed in the image of the target container.
