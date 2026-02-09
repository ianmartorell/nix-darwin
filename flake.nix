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
        appsModule = ./modules/mbp-apps.nix;
        homeModule = ./home/mbp-ian.nix;
      };

      # Mac Mini - minimal server setup with jarvis user for OpenClaw
      mini = let
        hostname = "mini";
        specialArgs = inputs // {
          inherit username fullname useremail hostname;
        };
      in
        darwin.lib.darwinSystem {
          inherit system specialArgs;
          modules = [
            ./modules/nix-core.nix
            ./modules/system.nix
            ./modules/mini-apps.nix
            ./modules/mini-system.nix
            ./modules/host-users.nix

            # Jarvis user for running OpenClaw AI agent (isolated for security)
            {
              users.users.jarvis = {
                home = "/Users/jarvis";
                description = "Jarvis - OpenClaw AI Agent";
              };
            }

            home-manager.darwinModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.backupFileExtension = "hm-backup";
              home-manager.extraSpecialArgs = specialArgs;
              home-manager.users.${username} = import ./home/mini-ian.nix;
              home-manager.users.jarvis = import ./home/mini-jarvis.nix;
            }
          ];
        };
    };

    # nix code formatter
    formatter.${system} = nixpkgs.legacyPackages.${system}.alejandra;
  };
}
