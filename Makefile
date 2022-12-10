.PHONY: default connect kubectl_common up down

default: develop/home/.gitconfig common/ssh/authorized_keys kubectl_common connect

connect:
	sleep 1
	kubectl wait deployment -l app=bastion --for condition=Available=True --timeout=20s || exit 1
	kubectl port-forward svc/bastion 2222:22

common/ssh/authorized_keys:
	if [ ! -f ~/.ssh/id_ed25519 ]; then \
		ssh-keygen -t ed25519 -q -N "" -f ~/.ssh/id_ed25519; \
	fi
	cp ~/.ssh/id_ed25519.pub common/ssh/authorized_keys

develop/home/.gitconfig:
	if [ -f ~/.gitconfig ]; then \
		cp ~/.gitconfig develop/home/.gitconfig; \
	else \
		touch develop/home/.gitconfig; \
	fi

kubectl_common:
	kubectl apply -k common 

up: common/ssh/authorized_keys develop/home/.gitconfig
	cd local && make up registry builder

down:
	cd local && make down
