{ hyprland, pkgs, ...}: {

  imports = [
    hyprland.homeManagerModules.default
    #./environment
    #./programs
    #./scripts
    #./themes
  ];

  home = {
    username = "brandom";
    homeDirectory = "/home/brandom";
  };

  home.packages = (with pkgs; [
    
    #User Apps
    librewolf
    cool-retro-term

    #utils
    ranger
    wlr-randr
    git
    rustup
    gnumake
    catimg
    curl
    appimage-run
    xflux
    dunst
    pavucontrol
    sqlite

    #misc 
    nano
    rofi
    wget
    grim
    slurp
    wl-clipboard
    pamixer
    tty-clock
    btop
    tokyo-night-gtk

  ]) ++ (with pkgs.gnome; [ 
    zenity
    gnome-tweaks
    eog
    gedit
  ]);


  programs.home-manager.enable = true;

  home.stateVersion = "23.05";
}
