include .env

.PHONY: run debug up down

run: up
	@echo ==================================================================
	@echo Connecting...
	@echo ==================================================================
	ssh ${CONTAINER_USER}@${app}.default

debug: up
	kubectl exec -it deployment/${app} -c main -- ${shell}

up:
	kubectl apply -k .
	sleep 1
	kubectl wait deployment -l app=${app} --for condition=Available=True --timeout=20s || exit 1

down:
	kubectl delete -k .

.env:
	echo "shell=zsh" >> .env
	echo "CONTAINER_USER=dev" >> .env
	@read -p "Input app name: " app && \
	echo "app=$${app}" >> .env
