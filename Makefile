default:
	ansible-playbook -i inventory -l target provision.yml --ask-sudo-pass

dotfiles:
	ansible-playbook -i inventory -l target provision-dotfiles.yml --ask-sudo-pass

system:
	ansible-playbook -i inventory -l target provision-system.yml --ask-sudo-pass
