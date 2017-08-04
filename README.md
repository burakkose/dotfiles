
# Overview

This repository is my personal template to tracking dotfiles via Ansible. It contains lots of personal applications and settings, so if you decide to use, please check the application list, and remove things you don’t want.

## What's in it?

* Window Manager: Openbox
* Bar: Tint2
* Launcher: Rofi
* Wallpaper Manager: feh
* Compositor: Compton
* System monitor: Conky
* Terminal: urxvt
* Shell: zsh

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
- feh
- firefox
- google-chrome
- gsimplecal
- gtk2
- gtk3
- i3lock-blur
- intellij-idea-ultimate-edition
- jdk8-openjdk
- jq
- l3afpad
- libreoffice-fresh
- lightdm
- lxappearance
- lxinput
- lxmenu-data
- numix-circle-icon-theme-git
- obconf
- obkey
- oblogout
- obmenu
- oh-my-zsh-git
- openbox
- openbox-menu
- pcmanfm
- plank
- powerline-fonts
- redshift
- rofi
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
- transmission-gtk
- ttf-inconsolata
- unrar
- vlc
- volumeicon
- wmctrl
- Xarchiver
- xorg-xinit
- xorg-xprop
```

## Installation

Make sure that, you are using correct configuration in ```vars/config.yml```

```
pacman -S ansible
cd && git clone https://github.com/burakkose/dotfiles.git && cd dotfiles && make
```

To update, `cd` into your local dotfiles repository and then:

``` make ```

You can also only apply dotfiles

```make dotfiles```

or system

```make system```
