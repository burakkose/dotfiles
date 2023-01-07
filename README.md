
# Overview

This repository provides a template for managing dotfiles using Ansible on Arch Linux and Ubuntu. It includes a selection of personal applications and configurations, with i3 as the default window manager. Review the list of included applications before using this template and remove any you do not want.

## What's in it?

* Window Manager: i3 (default), Openbox
* Bar: Polybar (default), Tint2
* Launcher: Rofi
* Wallpaper Manager: feh (only in i3)
* Compositor: Compton (only in Openbox)
* System monitor: Conky (only in Openbox)
* Terminal: urxvt
* Shell: zsh
* AUR Helper for Arch: trizen

After installation, you will have the following packages.
#### Arch Linux
> See roles/system/vars/main.yml for the full package list.

#### Ubuntu
> See oles/system-ubuntu/vars/main.yml for the full package list.

## Installation

Before proceeding with the installation, review the configuration in ```vars/config.yml```. This file contains important variables such as the user name and the location of the dotfiles repository.

After provisioning the dotfiles, you may notice some encrypted files. These files are protected using ansible vault and should be removed if they are not needed. Remember, do not keep sensitive info in Github, I only use this for hiding content in Github, not for protecting to encrypt.

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
Ansible vault is used to encrypt or decrypt sensitive data. The current list of encrypted files can be found in ```vars/vault.yml```

```make encrypt``` or ```make decrypt```

Note: Update the user name in ```vars/config.yml``` to match the user on your system.
