{
  description = "Amadeus flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager }@inputs: {
    nixosConfigurations.amadeus = nixpkgs.lib.nixosSystem {
      specialArgs = { inherit inputs; };
      modules = [
        ./configuration.nix
        home-manager.nixosModules.default
      	home-manager.nixosModules.home-manager
      	{
      	  home-manager.useGlobalPkgs = true;
      	  home-manager.users.toji = import ./home.nix;
      	  home-manager.backupFileExtension = "hm-backup";
      	}
      ];
    };

    nixpkgs.overlays = [
      (final: prev: {
        hyprland = prev.hyprland.overrideAttrs (old: {
          postInstall = old.postInstall + ''
            mkdir -p $out/share/hypr
            cp ./amadeus/Wallpapers/blue-clouds.png $out/share/hypr/wall0.png
          '';
        });
      })
    ];
  };
}
