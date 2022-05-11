.PHONY: user

user:
	USER_SSH="user-ssh" ./user/create_ssh_pubkeys.sh
	kubectl apply -f user/service_account.yaml
