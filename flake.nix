{
  description = "redwiz's nixos system flake";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";

    codex-desktop-linux = {
      url = "github:ilysenko/codex-desktop-linux";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    codex-cli = {
      url = "github:openai/codex";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.rust-overlay.follows = "rust-overlay";
    };

    rust-overlay = {
      url = "github:oxalica/rust-overlay";
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
      codexCliCargoToml = builtins.fromTOML (builtins.readFile "${inputs.codex-cli}/codex-rs/Cargo.toml");
      codexCliCargoVersion = codexCliCargoToml.workspace.package.version;
      codexCliVersion =
        if codexCliCargoVersion != "0.0.0" then
          codexCliCargoVersion
        else
          "0.0.0-dev+${inputs.codex-cli.shortRev or "dirty"}";
    in
    {
      overlays.default = final: prev: {
        codex-cli =
          (final.callPackage "${inputs.codex-cli}/codex-rs" {
            version = codexCliVersion;
            rustPlatform = final.makeRustPlatform {
              cargo = final.rust-bin.stable.latest.minimal;
              rustc = final.rust-bin.stable.latest.minimal;
            };
          }).overrideAttrs
            (oldAttrs: {
              cargoDeps = final.rustPlatform.importCargoLock {
                lockFile = "${oldAttrs.src}/Cargo.lock";
                outputHashes = {
                  "ratatui-0.29.0" = "sha256-HBvT5c8GsiCxMffNjJGLmHnvG77A6cqEL+1ARurBXho=";
                  "crossterm-0.28.1" = "sha256-6qCtfSMuXACKFb9ATID39XyFDIEMFDmbx6SSmNe+728=";
                  "nucleo-0.5.0" = "sha256-Hm4SxtTSBrcWpXrtSqeO0TACbUxq3gizg1zD/6Yw/sI=";
                  "nucleo-matcher-0.3.1" = "sha256-Hm4SxtTSBrcWpXrtSqeO0TACbUxq3gizg1zD/6Yw/sI=";
                  "runfiles-0.1.0" = "sha256-uJpVLcQh8wWZA3GPv9D8Nt43EOirajfDJ7eq/FB+tek=";
                  "tokio-tungstenite-0.28.0" = "sha256-V1xmnrfRWOcZZogelZEA4vvyMj2awCfHVA5/glQ6KAI=";
                  "tungstenite-0.27.0" = "sha256-VVHhk7l9J/sEmG3q/UuV/sQ3f+fGsmq5vumSy8vbMvw=";
                  "libwebrtc-0.3.26" = "sha256-gkXY6kr9ETnRC62TkKgKhqvxPTdACEWaTbtNALhRvAM=";
                };
              };
              RUSTY_V8_ARCHIVE = final.fetchurl {
                url = "https://github.com/denoland/rusty_v8/releases/download/v149.2.0/librusty_v8_release_x86_64-unknown-linux-gnu.a.gz";
                hash = "sha256-iu2YY323533Iv7i7R1nsW95HLQv3lD9Y4OYqNQlFxVk=";
              };
              cargoBuildFlags = [
                "-p"
                "codex-cli"
                "--bin"
                "codex"
              ];
            });

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
            {
              nixpkgs.overlays = [
                inputs.rust-overlay.overlays.default
                self.overlays.default
              ];
            }
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
