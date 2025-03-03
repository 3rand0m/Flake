{
  description = "My flake";
  
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprland.url = "github:hyprwm/Hyprland";
  };

  outputs = { self, nixpkgs, home-manager, hyprland, ... }: 
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;  
      };
      lib = nixpkgs.lib;
    in {
      nixosConfigurations = {
        brandom = lib.nixosSystem rec {
          inherit system;
          specialArgs = { inherit hyprland; };
          modules = [ 
            ./nixos/configuration.nix
            hyprland.nixosModules.default
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.brandom = import ./home/home.nix;
              home-manager.extraSpecialArgs = specialArgs;
            }
          ];
        };
      };
      # Define packages output
      packages.${system} = {
        default = hyprland.packages.${system}.hyprland; # Use Hyprland as the default package
        # Optionally, expose more packages explicitly
        hyprland = hyprland.packages.${system}.hyprland; # Explicitly named package
        hello = pkgs.hello; # Another package for testing
      };
    };
}