PACKAGES=(
    # DWM dependencies
    base-devel
    git
    libx11
    libxft
    libxinerama
    # Xorg tools/dependencies
    xorg-server
    xorg-setxkbmap
    xorg-xev
    xorg-xinit
    xorg-xprop    
    xorg-xrandr
    xorg-xsetroot
    # Display/Login manager
    greetd
    # Audio
    pamixer
    pipewire-pulse
    playerctl
    wireplumber
    # App launcher
    dmenu
    # Wallpapers
    feh
    # Compositor (anti-tearing/transparency)
    picom
    # Blue light filter
    redshift
    # Symlink manager for dotfiles
    stow
    # Screenshots
    maim
    xclip
    # Notifications
    libnotify
    dunst
    # Terminal
    alacritty
    tmux
    # Browser
    firefox
    # Editor
    neovim
    # Keyboard remapping
    keyd
    # Other
    fastfetch
    mpv
    yt-dlp
)

if lspci -nn | grep -Ei 'VGA|3D|Display' | grep -qi 'nvidia'; then
    sudo pacman -S --noconfirm nvidia
fi

if ! command -v nmcli; then
    sudo pacman -S --noconfirm networkmanager
    sudo systemctl enable NetworkManager.service
fi

sudo pacman -S --noconfirm "${PACKAGES[@]}"
