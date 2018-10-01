arch:
	ansible-playbook -i inventory -l target provision.yml --ask-become-pass

ubuntu:
	ansible-playbook -i inventory -l target provision-ubuntu.yml --ask-become-pass

dotfiles:
	ansible-playbook -i inventory -l target provision-dotfiles.yml --ask-become-pass

system-arch:
	ansible-playbook -i inventory -l target provision-system.yml --ask-become-pass

system-ubuntu:
	ansible-playbook -i inventory -l target provision-system-ubuntu.yml --ask-become-pass

decrypt:
	ansible-playbook -i inventory -l target decrypt.yml

encrypt:
	ansible-playbook -i inventory -l target encrypt.yml

install-deps-arch:
	sudo pacman -S ansible --needed

install-deps-ubuntu:
	sudo apt-add-repository ppa:ansible/ansible && sudo apt-get update && sudo apt-get install ansible
