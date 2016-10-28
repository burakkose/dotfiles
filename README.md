
# Overview
This repository is my personal template to tracking dotfiles. It contains lots of personal applications and settings, so if you decide to use installer script, please check the application list, review the code, and remove things you don’t want.
 
**Not: If you are willing to use installer script, you need to have Arch Linux. Otherwise, you need to do manually.**

## What's in it?

* Window Manager: Openbox
* Bar: Tint2
* Launcher: Rofi
* Wallpaper Manager: feh
* Compositor: Compton
* System monitor: Conky 
* Terminal: Terminator
* Shell: zsh

After installation, you will have these packages and packages groups.

```
yaourt
zsh
base 
base-devel 
file-roller 
powerline-fonts 
arandr 
pcmanfm 
vlc 
openbox-menu 
lxappearance 
lxinput 
scrot 
obmenu 
obconf 
obkey 
oblogout 
lxmenu-data 
leafpad 
spotify 
intellij-idea-ultimate-edition 
terminator 
rofi 
tint2 
firefox 
conky 
plank 
slack-desktop 
telegram-desktop-bin 
atom-editor-bin 
thunderbird 
popcorntime-bin 
google-chrome 
transmission-gtk 
docker 
compton 
gtk2 
gtk3 
feh 
openbox 
thunar 
xorg-xinit 
volumeicon 
lightdm 
jdk8-openjdk 
sbt 
scala 
clojure 
numix-circle-icon-theme-git 
thefuck 
the_silver_searcher 
jq 
ttf-inconsolata
```

Install script also contains Firefox plugins. Here is the list of plugins that is installed automatically

```
  # -> AdBlocker
  # -> Developer Tools - toolbar button
  # -> Firebug
  # -> FireStorage Plus
  # -> Grammarly
  # -> S3.Google Translator
  # -> Screengrab
  # -> Send to Kindle
  # -> VimFx
```

## Installation

``` cd && git clone https://github.com/burakkose/dotfiles.git && cd dotfiles && sh install.sh ```

To update, `cd` into your local dotfiles repository and then:

``` sh install.sh ```

Add your user name to configs file.
```
config/openbox/autostart
zshrc
```