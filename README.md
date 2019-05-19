

# Overview

This repository is my template to track dotfiles via Ansible for Arch and Ubuntu 16.04. It contains a lot of personal applications and settings. Before you decide to use it, please check the application list, and remove things you don’t want to have.

## What's in it?

* Window Manager: Openbox/i3
* Bar: Tint2/Polybar
* Launcher: Rofi
* Wallpaper Manager: feh
* Compositor: Compton
* System monitor: Conky
* Terminal: urxvt
* Shell: zsh
* AUR Helper for Arch: trizen

After installation, you will have the following packages.
#### Arch Linux
> Please see, roles/system/vars/main.yml

#### Ubuntu
> Please see, roles/system-ubuntu/vars/main.yml

## Installation

Please make sure that you are using a correct configuration in ```vars/config.yml```. You will realize some encrypted files after you provision dotfiles. These are files that I use Ansible Vault. You can safely remove them.

#### Arch
```
git clone https://github.com/burakkose/dotfiles.git 
cd dotfiles
make install-deps-arch && make arch
```

#### Ubuntu
```
git clone https://github.com/burakkose/dotfiles.git 
cd dotfiles
make install-deps-ubuntu && make ubuntu
```

If you only prefer to provision dotfiles

```make dotfiles```

#### Encryption & Decryption
Ansible Vault is used to encrypt or decrypt sensitive data. Please see ```vars/vault.yml``` for files that are currently encrypted. 

```make encrypt``` or ```make decrypt```

Note: Please change the username in ```vars/config.yml```.

