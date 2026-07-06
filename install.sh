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

LOGIN_DEPS=(greetd)

USER_PROGRAMS=(
    alacritty
    dmenu
    fastfetch
    feh
    firefox
    mpv
    neovim
    picom
    stow
    tmux
    yt-dlp
)

NERD_FONTS=(FiraCode)

WALLPAPERS=(
    apocalypse
    minimal
    monochrome
)

sudo dnf install -y "${BOOT_SPLASH_DEPS[@]}" "${DWM_DEPS[@]}" "${XORG_DEPS[@]}" "${LOGIN_DEPS[@]}" "${USER_PROGRAMS[@]}"

sudo grubby --update-kernel=ALL --args="rhgb quiet"

git clone https://github.com/rgarofano/dwm.git
(cd dwm && make && sudo make clean install)

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

git clone --depth 1 --filter=blob:none --sparse https://github.com/ryanoasis/nerd-fonts.git
cd nerd-fonts
for font in "${NERD_FONTS[@]}"; do
    git sparse-checkout add "patched-fonts/$font"
done
./install.sh "${NERD_FONTS[@]}"
cd ..
rm -rf nerd-fonts

git clone https://github.com/rgarofano/dotfiles.git
cd dotfiles
for package in */; do
    stow "$package"
done
cd ..

git clone --depth 1 --filter=blob:none --sparse https://github.com/rgarofano/wallpapers.git "$HOME/.local/share/wallpapers"
cd "$HOME/.local/share/wallpapers"
for theme in "${WALLPAPERS[@]}"; do
    git sparse-checkout add "$theme"
done
cd -

cat <<EOF > "$HOME/.xinitrc"
xrdb -merge <<< "Xft.dpi: 144"
xrandr --output DP-0 --mode 3840x2160 --rate 120

setxkbmap -option caps:escape
xmodmap -e "keycode 135 = Super_L"

picom --backend glx --vsync &

feh --bg-scale "$(find $HOME/.local/share/wallpapers -type f -name '*.jpg' | shuf -n 1)"

exec dwm
EOF
