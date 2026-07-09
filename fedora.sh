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
    pipewire-pulseaudio
    pamixer
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

sudo dnf copr enable -y alternateved/keyd
sudo dnf install -y "${PACKAGES[@]}"

# Update boot splash screen
sudo grubby --update-kernel=ALL --args="rhgb quiet"
