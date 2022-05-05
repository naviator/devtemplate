.PHONY: default machine machine_stop machine_nuke user

include .env

default: machine user

machine: .env
	if [ ! -d ${HOME}/.lima/${MACHINE} ]; then \
		limactl start --name=${MACHINE} machine/${MACHINE}.yaml; \
	else \
		limactl start ${MACHINE}; \
	fi
	K3S_CONFIG=${HOME}/.lima/${MACHINE}/conf/kubeconfig.yaml; \
	if [ ! -f $${K3S_CONFIG} ]; then \
		mkdir -p "${HOME}/.lima/${MACHINE}/conf"; \
		limactl shell default sudo cat /etc/rancher/k3s/k3s.yaml > $${K3S_CONFIG}; \
	fi
	cd machine/registry && MACHINE=${MACHINE} ./generate_tls.sh
	kubectl apply -f machine/registry/

machine_stop:
	limactl stop -f ${MACHINE}

machine_nuke: machine_stop
	sleep 3
	limactl delete ${MACHINE}

user:
	USER_SSH="user-ssh" ./user/create_ssh_pubkeys.sh
	kubectl apply -f user/service_account.yaml

.env:
	echo "MACHINE=default" > .env
	echo "USER=dev" >> .env
