# Local development environment

## Setup

### Mac OS X

Install LIMA-VM: `https://github.com/lima-vm/lima#installation`

Create lima-vm machine using included config file:
```
make machine
```

Copy KUBECONFIG file:
```
limactl shell default sudo cat /etc/rancher/k3s/k3s.yaml > ~/.kube/lima-config
sed -i '' 's/ default/ lima/g' ~/.kube/lima-config
```

## Persistence

On localhost, PVC for pods can use local-path with:

```
  storageClassName: local-path
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
