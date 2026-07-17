PACKAGES=(
    # Nicer boot splash screen
    plymouth
    # DWM dependencies
    gcc 
    git
    libX11-devel
    libXft-devel
    libXinerama-devel
    make
    # Xorg tools/dependencies
    setxkbmap
    xev
    xorg-x11-server-Xorg
    xorg-x11-xinit
    xprop    
    xrandr
    xrdb
    xsetroot
    # Display/Login manager
    greetd
    # Audio
    pamixer
    pipewire-pulseaudio
    playerctl
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
    mpv
    yt-dlp
)

sudo dnf copr enable -y alternateved/keyd
sudo dnf install -y "${PACKAGES[@]}"

if lspci -nn | grep -Ei 'VGA|3D|Display' | grep -qi 'nvidia'; then
    sudo dnf install -y https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
    sudo dnf install -y akmod-nvidia
fi

# Update boot splash screen
sudo grubby --update-kernel=ALL --args="rhgb quiet"
