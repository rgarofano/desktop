#!/usr/bin/env bash

NERD_FONTS=(FiraCode)

WALLPAPERS=(
    apocalypse
    minimal
    monochrome
)

SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)

# Install required packages
. /etc/os-release
case "$ID" in
    debian|ubuntu)
        . "$SCRIPT_DIR/packages/debian.sh"
        ;;
    fedora)
        . "$SCRIPT_DIR/packages/fedora.sh"
        ;;
    arch)
        . "$SCRIPT_DIR/packages/arch.sh"
        ;;

    *)
        echo "Error: unsupported distribution \'$ID\'" >&2
        exit 1
esac

# Deploy scripts
mkdir -p "$HOME/.local/bin"
cp "$SCRIPT_DIR/scripts/*" "$HOME/.local/bin"
sudo cp "$HOME/.local/bin/update-network-status" /etc/NetworkManager/dispatcher.d/

# Deploy icons
mkdir -p "$HOME/.local/share/icons"
cp "$SCRIPT_DIR/icons/*" "$HOME/.local/share/icons"

# Install window manager
git clone https://github.com/rgarofano/dwm.git
(cd dwm && make && sudo make clean install)

# Install status bar
git clone https://github.com/rgarofano/dwmblocks.git
(cd dwmblocks && make && sudo make install)

# Setup autologin
sudo tee /etc/greetd/config.toml >/dev/null <<EOF
[terminal]
vt = 1

[default_session]
command = "agreety --cmd $SHELL"
user = "$USER"

[initial_session]
command = "startx"
user = "$USER"
EOF
sudo systemctl enable greetd.service

# Install nerd font(s) of choice
git clone --depth 1 --filter=blob:none --sparse https://github.com/ryanoasis/nerd-fonts.git
cd nerd-fonts
for font in "${NERD_FONTS[@]}"; do
    git sparse-checkout add "patched-fonts/$font"
done
./install.sh "${NERD_FONTS[@]}"
cd ..

# Deploy my dotfiles
git clone https://github.com/rgarofano/dotfiles.git
cd dotfiles
shopt -s dotglob
for package in */; do
    stow "$package"
    if [[ $package == "keyd" ]]; then
        sudo mkdir -p /etc/keyd
        sudo ln -sf "$HOME/.config/keyd/default.conf" /etc/keyd/default.conf
        sudo systemctl enable keyd.service
    fi
done
cd ..

# Download wallpapers
git clone --depth 1 --filter=blob:none --sparse https://github.com/rgarofano/wallpapers.git "$HOME/.local/share/wallpapers"
cd "$HOME/.local/share/wallpapers"
for theme in "${WALLPAPERS[@]}"; do
    git sparse-checkout add "$theme"
done
cd -

# Cleanup
rm -rf dwm
rm -rf dwmblocks
rm -rf nerd-fonts

echo "Installation complete! You can now reboot into your new system"
