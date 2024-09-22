# Overview
This repository provides a template for managing dotfiles using Ansible on Arch Linux and Ubuntu. It includes a curated selection of personal applications and configurations, with sway as the default window manager. Review the list of included applications before using this template and remove any that are unnecessary for your setup.

## What's Included?
* Window Manager: sway (default), i3, Openbox
* Window System: Wayland (default), X11 (i3 and Openbox)
* Bar: Waybar (default), Polybar, Tint2
* Launcher: Wofi (default), Rofi
* Wallpaper Manager: swaybg (sway only), feh (i3 only)
* Compositor: Compton (Openbox only)
* System Monitor: Conky (Openbox only)
* Terminal: foot, urxvt (i3 and Openbox)
* Shell: zsh
* AUR Helper (Arch): trizen

### Package List
*  **Arch Linux**: Refer to `roles/system/vars/main.yml` for the full list.
*  **Ubuntu**: Refer to `roles/system-ubuntu/vars/main.yml` for the full list.

## Installation
Before installation, review `vars/config.yml` for essential configurations such as the username and the location of the dotfiles repository.

Encrypted files may appear post-installation. These are protected using Ansible Vault and can be safely removed if not needed. Remember, do not store sensitive information in GitHub; encryption here is used primarily for obfuscation, not security.

### Arch Installation
```bash
git  clone  https://github.com/burakkose/dotfiles.git
cd  dotfiles
make  install-deps-arch  &&  make  arch
```

### Ubuntu Installation
As I primarily use Arch and not Ubuntu much these days, the Ubuntu setup will always lag behind.
```bash
git  clone  https://github.com/burakkose/dotfiles.git
cd  dotfiles
make  install-deps-ubuntu  &&  make  ubuntu
```

### To provision dotfiles only:
```bash
make  dotfiles
```

## Encryption & Decryption
Sensitive data is encrypted using Ansible Vault. The list of encrypted files can be found in `vars/vault.yml`. As mentioned above, do not store sensitive information here; encryption here is used primarily for obfuscation, not security.

Use the following commands to encrypt or decrypt:
```bash
make  encrypt
make  decrypt
```
*Note*: Ensure the username in `vars/config.yml` matches your system's username.