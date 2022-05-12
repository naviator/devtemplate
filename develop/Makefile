include .env

.PHONY: up down run build push image

up: run
	kubectl port-forward svc/${app} --address 0.0.0.0 2222:22

debug:
	kubectl exec -it deployment/${app} -c main -- ${shell}

run:
	kubectl apply -k .
	kubectl wait deployment -l app=${app} --for condition=Available=True --timeout=10s || exit 1
	sleep 1
	POD=$$(kubectl get pods --no-headers -o custom-columns=":metadata.name" -l app=${app}); \
	echo "rsync Git config to $${POD}"; \
	kubectl cp ${HOME}/.gitconfig -c main $${POD}:/data/.gitconfig;

down:
	kubectl delete -k .

image: build push

build: .env
	BUILDKIT_PROGRESS=plain TMPDIR=/tmp DOCKER_BUILDKIT=0 COMPOSE_DOCKER_CLI_BUILD=0 \
	${OCI} build -f Containerfile \
	-t ${IMAGE} \
	--build-arg USER=${CONTAINER_USER} \
	--build-arg UID=${CONTAINER_UID} \
	image/

push:
	${OCI} push ${IMAGE}

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
	echo "Input app name now: "
	@read app && \
	echo "app=$${app}" >> .env && \
	echo "IMAGE=registry:5000/$${app}" >> .env
