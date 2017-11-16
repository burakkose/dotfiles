default:
	ansible-playbook -i inventory -l target provision.yml

dotfiles:
	ansible-playbook -i inventory -l target provision-dotfiles.yml

system:
	ansible-playbook -i inventory -l target provision-system.yml

install-deps:
	sudo pacman -S ansible --needed
