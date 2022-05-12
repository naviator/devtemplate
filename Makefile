.PHONY: user

user:
	cd user && USER_SSH="user-ssh" ./create_ssh_pubkeys.sh
	kubectl apply -f user/service_account.yaml
