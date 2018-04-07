# Overview

This repository is my personal template to tracking dotfiles via Ansible in Arch Linux. It contains lots of personal applications and settings, so if you decide to use, please check the application list, and remove things you don’t want.

## What's in it?

* Window Manager: Openbox
* Bar: Tint2
* Launcher: Rofi
* Wallpaper Manager: feh
* Compositor: Compton
* System monitor: Conky
* Terminal: urxvt
* Shell: zsh
* AUR Helper: trizen

After installation, you will have these packages and packages groups.

> Please see, roles/system/vars/main.yml

```
  - arandr
  - arc-gtk-theme
  - atom-editor-bin
  - base
  - base-devel
  - cbatticon
  - clojure
  - compton
  - conky
  - docker
  - evince
  - feh
  - firefox-developer-edition
  - fpp-git
  - galculator
  - google-chrome
  - gsimplecal
  - gtk2
  - gtk3
  - htop
  - i3lock-blur
  - imagemagick
  - intellij-idea-ultimate-edition
  - jdk9-openjdk
  - jq
  - leafpad
  - libreoffice-fresh
  - lxappearance
  - lxinput
  - lxmenu-data
  - neofetch
  - network-manager-applet
  - networkmanager-openvpn
  - obconf
  - obkey
  - oblogout
  - obmenu
  - oh-my-zsh-git
  - openbox
  - openbox-menu
  - openssh
  - papirus-icon-theme
  - pcmanfm
  - powerline
  - powerline-fonts
  - ranger
  - rbenv
  - redshift
  - rofi
  - rxvt-unicode
  - sbt
  - scala
  - scrot
  - slack-desktop
  - spotify
  - telegram-desktop-bin
  - the_silver_searcher
  - thefuck
  - thunderbird
  - tig
  - tint2
  - tmux
  - tpm
  - transmission-gtk
  - ttf-inconsolata
  - ttf-ms-fonts
  - unrar
  - urxvt-perls
  - vlc
  - volumeicon
  - wmctrl
  - xarchiver
  - xclip
  - xorg
  - xorg-xinit
  - xorg-xclipboard
```

## Installation

Make sure that, you are using correct configuration in ```vars/config.yml```. You should also know how Ansible Vault works, please use correct sudo pass(ansible_sudo_pass) in ```vars/sudo-local.yml```.

```
cd
git clone https://github.com/burakkose/dotfiles.git 
cd dotfiles
make install-deps
make
```

You can also only apply dotfiles

```make dotfiles```

or system

```make system```

Note: Please change the user name in ```data/gtkrc-2.0```, ```data/Xresources```.

