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

sudo pacman -Syu --noconfirm "${PACKAGES[@]}"
