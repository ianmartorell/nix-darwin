{
  description = "Nix for macOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-25.11-darwin";

    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    darwin = {
      url = "github:lnl7/nix-darwin/nix-darwin-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs @ {
    self,
    nixpkgs,
    darwin,
    home-manager,
    ...
  }: let
    system = "aarch64-darwin";
    username = "ian";
    fullname = "Ian Martorell";
    useremail = "ianmartorell@gmail.com";

    # Helper function to create darwin configurations
    mkDarwinConfig = {
      hostname,
      appsModule ? ./modules/apps.nix,
      homeModule ? ./home,
    }: let
      specialArgs = inputs // {
        inherit username fullname useremail hostname;
      };
    in
      darwin.lib.darwinSystem {
        inherit system specialArgs;
        modules = [
          ./modules/nix-core.nix
          ./modules/system.nix
          appsModule
          ./modules/host-users.nix

          home-manager.darwinModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.backupFileExtension = "hm-backup";
            home-manager.extraSpecialArgs = specialArgs;
            home-manager.users.${username} = import homeModule;
          }
        ];
      };
  in {
    darwinConfigurations = {
      # MacBook Pro - full desktop setup
      mbp = mkDarwinConfig {
        hostname = "mbp";
        appsModule = ./modules/apps.nix;
        homeModule = ./home;
      };

      # Mac Mini - minimal server setup
      mini = mkDarwinConfig {
        hostname = "mini";
        appsModule = ./modules/apps-mini.nix;
        homeModule = ./home/mini.nix;
      };
    };

    # nix code formatter
    formatter.${system} = nixpkgs.legacyPackages.${system}.alejandra;
  };
}
