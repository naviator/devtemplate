.PHONY: up down prune_machine

include .env

K3S_CONFIG:=${PWD}/.KUBECONFIG

up: .env
	if [ ! -d ${HOME}/.lima/${MACHINE} ]; then \
		limactl start --name=${MACHINE} machine.yaml; \
	else \
		limactl start ${MACHINE}; \
	fi
	yq --version
	if [ ! -f ${K3S_CONFIG} ]; then \
		mkdir -p "${HOME}/.lima/${MACHINE}/conf"; \
		limactl shell ${MACHINE} sudo cat /etc/rancher/k3s/k3s.yaml > ${K3S_CONFIG}; \
	fi
	yq e -i '.users[0].name = "${MACHINE}"' ${K3S_CONFIG}
	yq e -i '.clusters[0].name = "${MACHINE}"' ${K3S_CONFIG}
	yq e -i '.contexts[0].context.cluster = "${MACHINE}"' ${K3S_CONFIG}
	yq e -i '.contexts[0].context.user = "${MACHINE}"' ${K3S_CONFIG}
	yq e -i '.contexts[0].name = "${MACHINE}"' ${K3S_CONFIG}
	yq e -i '.current-context = "${MACHINE}"' ${K3S_CONFIG}
	@echo "=================================================================================================="
	@echo "Make sure that ${K3S_CONFIG} is set in KUBECONFIG"
	@echo "=================================================================================================="

down:
	limactl stop -f ${MACHINE} || echo "Could not stop machine"

prune_machine: down
	sleep 3
	limactl delete ${MACHINE}; \
	rm -f ${PWD}/.KUBECONFIG

.env:
	@read -p "Input machine name [devnode]: " MACHINE && \
	export MACHINE="$${MACHINE:-devnode}" && \
	echo "MACHINE=$${MACHINE}" >> .env
