.PHONY: default connect kubectl_common up down test_k8s

default: kubectl_common connect

connect:
	kubectl port-forward svc/bastion 2222:2222

common/ssh/authorized_keys:
	if [ ! -f ~/.ssh/id_ed25519 ]; then \
		ssh-keygen -t ed25519 -q -N "" -f ~/.ssh/id_ed25519; \
	fi
	cp ~/.ssh/id_ed25519.pub common/ssh/authorized_keys

common/home/.gitconfig:
	if [ -f ~/.gitconfig ]; then \
		cp ~/.gitconfig develop/home/.gitconfig; \
	else \
		touch common/home/.gitconfig; \
	fi

kubectl_common: common/home/.gitconfig common/ssh/authorized_keys 
	kubectl apply -k common
	sleep 0.1
	kubectl wait deployment -l naviator.github.io/devtemplate=bastion --for condition=Available=True --timeout=20s || exit 1

up: common/ssh/authorized_keys develop/home/.gitconfig
	cd local && make up registry builder

down:
	cd local && make down

test_k8s: kubectl_common
	make connect &
	kubectl wait deployment -l naviator.github.io/devtemplate=bastion --for condition=Available=True --timeout=20s || exit 1
	sleep 3
	sh test/connect.sh
