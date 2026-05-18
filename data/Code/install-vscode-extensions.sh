#!/usr/bin/env bash
# install-vscode-extensions.sh — provision the VS Code extension set.
#
# Idempotent: queries `code --list-extensions` and only installs the
# ones that are missing, so re-runs on already-provisioned machines
# are cheap and quiet. Bails out cleanly when `code` is unavailable
# so the ansible dotfile role can call it unconditionally.

set -euo pipefail

if ! command -v code >/dev/null 2>&1; then
    echo "code not installed; skipping VS Code extension provisioning"
    exit 0
fi

EXTENSIONS=(
    # Theme + icons (matches the desktop-wide Catppuccin Mocha palette)
    Catppuccin.catppuccin-vsc
    Catppuccin.catppuccin-vsc-icons

    # Keybindings + ergonomics
    alphabotsec.vscode-eclipse-keybindings
    christian-kohler.path-intellisense
    eamodio.gitlens

    # Web
    ecmel.vscode-html-css

    # Python
    ms-python.debugpy
    ms-python.isort
    ms-python.python
    ms-python.vscode-pylance

    # Remote / containers
    ms-vscode-remote.remote-containers
    ms-vscode-remote.remote-ssh
    ms-vscode-remote.remote-ssh-edit
    ms-vscode-remote.vscode-remote-extensionpack
    ms-vscode.remote-explorer
    ms-vscode.remote-server

    # C / C++ / CMake
    ms-vscode.cmake-tools
    ms-vscode.cpptools
    ms-vscode.cpptools-extension-pack
    ms-vscode.cpptools-themes
    twxs.cmake

    # DevOps / data
    redhat.ansible
    redhat.vscode-yaml
    zainchen.json
)

installed=$(code --list-extensions 2>/dev/null | tr '[:upper:]' '[:lower:]' | sort -u)
added=0
failed=0

for ext in "${EXTENSIONS[@]}"; do
    lower=${ext,,}
    if printf '%s\n' "$installed" | grep -qFx "$lower"; then
        continue
    fi
    echo "Installing $ext"
    if ! code --install-extension "$ext" --log error --force >/dev/null; then
        echo "  FAILED to install $ext" >&2
        failed=$((failed + 1))
        continue
    fi
    added=$((added + 1))
done

if (( added == 0 && failed == 0 )); then
    echo "All VS Code extensions already installed"
else
    echo "Installed $added new VS Code extension(s); $failed failed"
fi
exit 0
