PACKAGES=(
    # DWM dependencies
    build-essential
    git
    libx11-dev
    libxft-dev
    libxinerama-dev
    # Xorg tools/dependencies
    x11-utils           # xev
    x11-xkb-utils       # setxkbmap
    x11-xserver-utils   # xrdb, xrandr, xsetroot, xprop
    xinit
    xserver-xorg-core
    # Display/Login manager
    greetd
    # Audio
    pamixer
    pipewire-pulse
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
    libnotify-bin
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

sudo apt-get update && sudo apt-get install -y "${PACKAGES[@]}"
