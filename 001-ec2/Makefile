DIR_KEY=keys
NAME_KEY=tut001

.PHONY: all

all: help

## Build:
init: ## Init TF Project
	terraform init 

format: ## Format TF Files
	terraform fmt

validate: format ## Validate TF Files
	terraform validate

keygen: ## Generate SSH keys
	@mkdir -p ${DIR_KEY}
	@ssh-keygen -m PEM -f ${DIR_KEY}/${NAME_KEY}.pem
	@chmod 400 ${DIR_KEY}/${NAME_KEY}.pem

apply: validate ## Run TF Project
	terraform apply

destroy: ## Destroy TF Project
	terraform destroy
	@rm -rf ${DIR_KEY}

## Help:
help: ## Show this help.
	@echo ''
	@echo 'Usage:'
	@echo '  make <target>'
	@echo ''
	@echo 'Targets:'
	@awk 'BEGIN {FS = ":.*?## "} { \
		if (/^[a-zA-Z_-]+:.*?##.*$$/) {printf "    %-20s%s\n", $$1, $$2} \
		else if (/^## .*$$/) {printf "  %s\n", substr($$1,4)} \
		}' $(MAKEFILE_LIST)
