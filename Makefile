.PHONY: machine machine_stop machine_nuke user

include .env

machine: .env
	if [ ! -d ${HOME}/.lima/${MACHINE} ]; then \
		limactl start --name=${MACHINE} machine/default.yaml; \
	else \
		limactl start default; \
	fi
	mkdir -p "${HOME}/.lima/${MACHINE}/conf"
	K3S_CONFIG=${HOME}/.lima/${MACHINE}/conf/kubeconfig.yaml; \
	if [ ! -f $${K3S_CONFIG} ]; then \
		limactl shell default sudo cat /etc/rancher/k3s/k3s.yaml > $${K3S_CONFIG}; \
	fi
	cd machine/registry && MACHINE=${MACHINE} ./generate_tls.sh
	kubectl apply -f machine/persistence.yaml
	kubectl apply -f machine/registry/

machine_stop:
	limactl stop ${MACHINE}

machine_nuke: machine_stop
	limactl delete ${MACHINE}

user:
	USER_SSH="${USER}-ssh" ./user/create_ssh_pubkeys.sh
	kubectl apply -f user/${USER}.yaml

.env:
	echo "MACHINE=default" > .env
	echo "USER=dev" >> .env
