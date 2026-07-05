#!/usr/bin/env bash

BOOT_SPLASH_DEPS=(plymouth)
DWM_DEPS=(git make gcc libXft-devel libX11-devel libXinerama-devel xorg-x11-server-Xorg dmenu)
LOGIN_DEPS=(greetd xorg-x11-xinit)

# Prompt for password immediately
sudo -n true

sudo dnf install -y "${BOOT_SPLASH_DEPS[@]}"
sudo grubby --update-kernel=ALL --args="rhgb quiet"

sudo dnf install -y "${DWM_DEPS[@]}"
git clone https://github.com/rgarofano/dwm.git
(cd dwm && make && sudo make clean install)

sudo dnf install -y "${LOGIN_DEPS[@]}"
cat <<EOF > "$HOME/.xinitrc"
#!/usr/bin/env bash
exec dwm
EOF
chmod +x "$HOME/.xinitrc"
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
