include .env

.PHONY: build push up down home home_secrets default

up:
	kubectl apply -f main.yaml
	sleep 1
	POD=$$(kubectl get pods --no-headers -o custom-columns=":metadata.name" -l app=${app}); \
	echo "rsync Git config to $${POD}"; \
	kubectl cp ${HOME}/.gitconfig -c main $${POD}:/data/.gitconfig;
	kubectl exec -it deployment/maintenance -c main -- ${shell}

down:
	kubectl delete -f main.yaml

build: .env
	BUILDKIT_PROGRESS=plain TMPDIR=/tmp DOCKER_BUILDKIT=0 COMPOSE_DOCKER_CLI_BUILD=0 \
	${OCI} build -f Containerfile \
	-t ${IMAGE} \
	--build-arg USER=${CONTAINER_USER} \
	--build-arg UID=${CONTAINER_UID} \
	.

push:
	${OCI} push ${IMAGE}

secrets:
	@echo "rsync secrets in a few seconds, make sure you trust this project. ABORT otherwise..."; \
	sleep 3
	POD=$$(kubectl get pods --no-headers -o custom-columns=":metadata.name" -l app=${app}); \
	../../sync.sh -ra ${HOME}/.ssh/ $${POD}:/data/.ssh; \
	../../sync.sh -ra ${HOME}/.gnupg/ $${POD}:/data/.gnupg

.env:
	if command -v podman; then \
		echo "OCI=podman" > .env; \
	elif command -v docker; then \
		echo "OCI=docker" > .env; \
	else \
		echo "No virtualization found..."; \
		exit 1; \
	fi
	echo "shell=zsh" >> .env
	echo "CONTAINER_USER=dev" >> .env
	echo "CONTAINER_UID=1000" >> .env
	echo "IMAGE=registry:5000/maintenance" >> .env
	echo "Input app name now: "
	@read app && echo "app=$${app}" >> .env
