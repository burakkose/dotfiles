#!/bin/bash

# Visual Studio Code :: Package list
pkglist=(
alphabotsec.vscode-eclipse-keybindings
Equinusocio.vsc-community-material-theme
Equinusocio.vsc-material-theme
equinusocio.vsc-material-theme-icons
ms-python.isort
ms-python.python
ms-python.vscode-pylance
ms-vscode-remote.remote-containers
ms-vscode-remote.remote-ssh
ms-vscode-remote.remote-ssh-edit
ms-vscode-remote.remote-wsl
ms-vscode-remote.vscode-remote-extensionpack
ms-vscode.cpptools-themes
ms-vscode.remote-explorer
PKief.material-icon-theme
redhat.ansible
redhat.vscode-yaml
)

for i in ${pkglist[@]}; do
  code --install-extension $i --log error --force
done
