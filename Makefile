.PHONY: help install build
.DEFAULT_GOAL= help

help:
	@grep -E '(^[a-zA-Z_-]+:.*?##.*$$)|(^##)' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[32m%-10s\033[0m %s\n", $$1, $$2}' | sed -e 's/\[32m##/[33m/'

install: ## Install Ansible Galaxy roles
	ansible-galaxy install -p galaxy_roles -r requirements.yml

build: install  ## Build Packer image
	packer build -only=openstack -var 'ssh_user=centos' -var 'source_image_id=2b9bdf70-aee6-4d27-adb0-681764ad594e' -var 'flavor=m1.small' template.json

clean:  ## Clean unused
	rm -rf galaxy_roles
	rm -f *.retry
	rm -f *.pem