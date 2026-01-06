.PHONY: dotfiles system-arch system-ubuntu decrypt encrypt lint \
        check check-system-arch check-system-ubuntu \
        install-deps-arch install-deps-ubuntu \
        container-arch-build container-arch-start container-arch-stop container-arch-test container-arch-shell container-arch-clean \
        container-ubuntu-build container-ubuntu-start container-ubuntu-stop container-ubuntu-test container-ubuntu-shell container-ubuntu-clean \
        container-clean-all

# Inventory is now configured in ansible.cfg
PLAYBOOK = ansible-playbook -l target

dotfiles:
	$(PLAYBOOK) provision-dotfiles.yml

system-arch:
	sudo $(PLAYBOOK) provision-system-arch.yml

system-ubuntu:
	sudo $(PLAYBOOK) provision-system-ubuntu.yml

decrypt:
	$(PLAYBOOK) decrypt.yml

encrypt:
	$(PLAYBOOK) encrypt.yml

lint:
	ansible-lint

check:
	$(PLAYBOOK) provision-dotfiles.yml --check --diff

check-system-arch:
	sudo $(PLAYBOOK) provision-system-arch.yml --check --diff

check-system-ubuntu:
	sudo $(PLAYBOOK) provision-system-ubuntu.yml --check --diff

install-deps-arch:
	sudo pacman -S ansible ansible-lint --needed

install-deps-ubuntu:
	sudo apt-add-repository -y ppa:ansible/ansible && sudo apt-get update && sudo apt-get install -y ansible ansible-lint

# Container testing for Arch Linux
CONTAINER_ARCH_IMAGE = dotfiles-arch-test
CONTAINER_ARCH_NAME = dotfiles-arch-test
CONTAINER_ARCH_PLAYBOOK = ansible-playbook -i inventory/docker-arch.yml -l target \
    -e '{"configs": {"dotfile_repo_path": "/home/testuser/dotfiles", "dotfile_backup_path": "/home/testuser/dotfiles.bak", "vm": "sway"}}'

container-arch-build:
	podman build -f Dockerfile.arch -t $(CONTAINER_ARCH_IMAGE) .

container-arch-start: container-arch-build
	@podman rm -f $(CONTAINER_ARCH_NAME) 2>/dev/null || true
	podman run -d --name $(CONTAINER_ARCH_NAME) $(CONTAINER_ARCH_IMAGE)

container-arch-stop:
	podman stop $(CONTAINER_ARCH_NAME) && podman rm $(CONTAINER_ARCH_NAME)

container-arch-test: container-arch-start
	$(CONTAINER_ARCH_PLAYBOOK) provision-system-arch.yml
	$(CONTAINER_ARCH_PLAYBOOK) provision-dotfiles.yml

container-arch-shell:
	podman exec -it $(CONTAINER_ARCH_NAME) bash

container-arch-clean:
	@podman rm -f $(CONTAINER_ARCH_NAME) 2>/dev/null || true
	@podman rmi $(CONTAINER_ARCH_IMAGE) 2>/dev/null || true

# Container testing for Ubuntu
CONTAINER_UBUNTU_IMAGE = dotfiles-ubuntu-test
CONTAINER_UBUNTU_NAME = dotfiles-ubuntu-test
CONTAINER_UBUNTU_PLAYBOOK = ansible-playbook -i inventory/docker-ubuntu.yml -l target \
    -e '{"configs": {"dotfile_repo_path": "/home/testuser/dotfiles", "dotfile_backup_path": "/home/testuser/dotfiles.bak", "vm": "sway"}}'

container-ubuntu-build:
	podman build -f Dockerfile.ubuntu -t $(CONTAINER_UBUNTU_IMAGE) .

container-ubuntu-start: container-ubuntu-build
	@podman rm -f $(CONTAINER_UBUNTU_NAME) 2>/dev/null || true
	podman run -d --name $(CONTAINER_UBUNTU_NAME) $(CONTAINER_UBUNTU_IMAGE)

container-ubuntu-stop:
	podman stop $(CONTAINER_UBUNTU_NAME) && podman rm $(CONTAINER_UBUNTU_NAME)

container-ubuntu-test: container-ubuntu-start
	$(CONTAINER_UBUNTU_PLAYBOOK) provision-system-ubuntu.yml
	$(CONTAINER_UBUNTU_PLAYBOOK) provision-dotfiles.yml

container-ubuntu-shell:
	podman exec -it $(CONTAINER_UBUNTU_NAME) bash

container-ubuntu-clean:
	@podman rm -f $(CONTAINER_UBUNTU_NAME) 2>/dev/null || true
	@podman rmi $(CONTAINER_UBUNTU_IMAGE) 2>/dev/null || true

# Clean all container resources
container-clean-all: container-arch-clean container-ubuntu-clean
