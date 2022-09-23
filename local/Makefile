.PHONY: up down registry builder

include .env

up: .env registry builder
	cd ${LOCAL_VM} && make up

down: .env
	cd ${LOCAL_VM} && make down

registry:
	cd registry && \
	./generate_tls.sh && \
	kubectl apply -f registry.yaml

builder:
	kubectl apply -k builder

.env:
	if [ $$(uname) = "Darwin" ]; then \
		echo "LOCAL_VM=macos" >> .env; \
	else \
		echo "LOCAL_VM=default" >> .env; \
	fi
