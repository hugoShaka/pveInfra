# If the first argument is "run"...

install:
	PYTHONUNBUFFERED=1 ANSIBLE_FORCE_COLOR=true ANSIBLE_HOST_KEY_CHECKING=false \
		ANSIBLE_SSH_ARGS='-o UserKnownHostsFile=/dev/null -o IdentitiesOnly=yes -o ControlMaster=auto -o ControlPersist=60s' \
		ansible-playbook --connection=ssh --timeout=30 --limit="all" \
		--inventory-file=/home/shaka/perso/infra/.vagrant/provisioners/ansible/inventory \
		--become -v install.yml

network:
	PYTHONUNBUFFERED=1 ANSIBLE_FORCE_COLOR=true ANSIBLE_HOST_KEY_CHECKING=false \
		 ANSIBLE_SSH_ARGS='-o UserKnownHostsFile=/dev/null -o IdentitiesOnly=yes -o ControlMaster=auto -o ControlPersist=60s' \
		ansible-playbook --connection=ssh --timeout=30 --limit="all" \
	--inventory-file=/home/shaka/perso/infra/.vagrant/provisioners/ansible/inventory \
	--become -v install.yml --tags="ingress,service-discovery"

test:
	PYTHONUNBUFFERED=1 ANSIBLE_FORCE_COLOR=true ANSIBLE_HOST_KEY_CHECKING=false \
		ANSIBLE_SSH_ARGS='-o UserKnownHostsFile=/dev/null -o IdentitiesOnly=yes -o ControlMaster=auto -o ControlPersist=60s' \
		ansible-playbook --connection=ssh --timeout=30 --limit="all" \
		--inventory-file=/home/shaka/perso/infra/.vagrant/provisioners/ansible/inventory \
		--become test.yml
