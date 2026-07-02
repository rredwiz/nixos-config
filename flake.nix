{
  description = "redwiz's nixos system flake";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";

    codex-desktop-linux = {
      url = "github:ilysenko/codex-desktop-linux";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    noctalia = {
      url = "github:noctalia-dev/noctalia/legacy-v4";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      noctalia,
      home-manager,
      ...
    }@inputs:
    let
      rojoVersion = "7.7.0";
    in
    {
      overlays.default = final: prev: {
        rojo = prev.rojo.overrideAttrs (
          finalAttrs: previousAttrs: {
            version = rojoVersion;

            src = final.fetchFromGitHub {
              owner = "rojo-rbx";
              repo = "rojo";
              tag = "v${finalAttrs.version}";
              hash = "sha256-2atNAiv51MNpxXdwvKSvtO1CGvQUOdUUOZszjAm3zi8=";
              fetchSubmodules = true;
            };

            cargoDeps = final.rustPlatform.fetchCargoVendor {
              inherit (finalAttrs) pname version src;
              hash = "sha256-1xTvW3Ra6erYpjxgfp2m8qVMz6u99WCDv2VE/Xh2mFc=";
            };
          }
        );
      };

      nixosConfigurations = {
        nixos = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inherit inputs; };
          modules = [
            { nixpkgs.overlays = [ self.overlays.default ]; }
            ./configuration.nix
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.redwiz = ./home.nix;
              home-manager.extraSpecialArgs = { inherit inputs; };
              home-manager.backupFileExtension = "backup";
            }
          ];
        };
      };
    };
}
