#!/usr/bin/env bash

shopt -s dotglob

BOOT_SPLASH_DEPS=(plymouth)

DWM_DEPS=(
    git
    make
    gcc 
    libXft-devel
    libX11-devel
    libXinerama-devel
)

XORG_DEPS=(
    setxkbmap
    xev
    xorg-x11-server-Xorg
    xorg-x11-xinit
    xprop    
    xrandr
    xrdb
    xsetroot
)

USER_PROGRAMS=(
    alacritty
    dmenu
    fastfetch
    firefox
    mpv
    neovim
    picom
    tmux
    yt-dlp
)

NERD_FONTS=(FiraCode)

# Prompt for password immediately
sudo -n true

sudo dnf install -y "${BOOT_SPLASH_DEPS[@]}"
sudo grubby --update-kernel=ALL --args="rhgb quiet"

sudo dnf install -y "${DWM_DEPS[@]}"
git clone https://github.com/rgarofano/dwm.git
(cd dwm && make && sudo make clean install)

sudo dnf install -y greetd "${XORG_DEPS[@]}"
cat <<EOF | sudo tee /etc/greetd/config.toml
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

sudo dnf install -y "${USER_PROGRAMS[@]}"

cat <<EOF > "$HOME/.xinitrc"
xrdb -merge <<< "Xft.dpi: 144"
xrandr --output DP-0 --mode 3840x2160 --rate 120

setxkbmap -option caps:escape
xmodmap -e "keycode 135 = Super_L"

picom --backend glx --vsync &

exec dwm
EOF

git clone --depth 1 --filter=blob:none --sparse https://github.com/ryanoasis/nerd-fonts.git
cd nerd-fonts
for font in "${NERD_FONTS[@]}"; do
    git sparse-checkout add "patched-fonts/$font"
done
./install.sh "${NERD_FONTS[@]}"
cd ..
rm -rf nerd-fonts

sudo dnf install -y stow
git clone https://github.com/rgarofano/dotfiles.git
cd dotfiles
for package in */; do
    stow "$package"
done
cd ..
