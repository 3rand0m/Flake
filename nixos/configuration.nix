{ config, pkgs, lib, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
      ../hosts/desktop
    ];

  boot.loader = {
    grub = {
      enable = true;
      device = "/dev/sda";
      useOSProber = true;
      efiSupport = false;
    };
  };

  boot.loader.grub.theme = pkgs.stdenv.mkDerivation {
    pname = "distro-grub-themes";
    version = "3.1";
    src = pkgs.fetchFromGitHub {
      owner = "AdisonCavani";
      repo = "distro-grub-themes";
      rev = "v3.1";
      hash = "sha256-ZcoGbbOMDDwjLhsvs77C7G7vINQnprdfI37a9ccrmPs=";
    };
    installPhase = "cp -r customize/nixos $out";
  };

  networking.hostName = "nixos";
  networking.networkmanager.enable = true;

  time.timeZone = "America/Chicago";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "pt_BR.UTF-8";
    LC_IDENTIFICATION = "pt_BR.UTF-8";
    LC_MEASUREMENT = "pt_BR.UTF-8";
    LC_MONETARY = "pt_BR.UTF-8";
    LC_NAME = "pt_BR.UTF-8";
    LC_NUMERIC = "pt_BR.UTF-8";
    LC_PAPER = "pt_BR.UTF-8";
    LC_TELEPHONE = "pt_BR.UTF-8";
    LC_TIME = "pt_BR.UTF-8";
  };

   services.xserver = {
   enable = true;
    # X11 keymap
    layout = "us";
    xkb.variant = "";
  };

  #Opengl
  hardware.graphics = {
    enable = true;
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  programs.steam = {
   enable = true;
   remotePlay.openFirewall = true;
   dedicatedServer.openFirewall = true;
  };

  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # add /.local to $PATH
  environment.variables={
   NIXOS_OZONE_WL = "1";
   PATH = [
     "\${HOME}/.local/bin"
     "\${HOME}/.config/rofi/scripts"
   ];
   #PKG_CONFIG_PATH = lib.makeLibraryPath [ libevdev ];
  };

  environment.systemPackages = with pkgs; [
  libevdev
];
  
  users.users.brandom = {
    isNormalUser = true;
    description = "Brandon";
    extraGroups = [ "networkmanager" "wheel" "vboxsf" "video" "input" "docker" ];
    packages = with pkgs; [
      firefox
      (opera.override { proprietaryCodecs = true; })
      neofetch
   ];
  };

  #Garbage colector
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };

  system.autoUpgrade = {
   enable = true;
   channel = "https://nixos.org/channels/nixos-24.11";
  };
 
  system.stateVersion = "24.11";
  
  #Flakes
  nix = {
    package = pkgs.nixVersions.git;
    extraOptions = "experimental-features = nix-command flakes";
 };
}
