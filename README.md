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

## Install local registry

Installing registry allows to build development images on localhost. It also generates TLS certificate for you and installs it in local VM for `kubelet` to use.

```
kubectl apply -f machine/registry/
```

## Syncing with localhost

Sync remote container folder with local folder with `rsync`. Example:
```
./sync.sh -ra go:/workspace/ workspace/
```
`rsync` needs to be installed in the image of the target container.
