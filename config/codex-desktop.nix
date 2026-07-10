{ inputs, pkgs, ... }:

let
  system = pkgs.stdenv.hostPlatform.system;
  codexDmgUrl = "https://persistent.oaistatic.com/codex-app-prod/ChatGPT.dmg";
  staleCodexDmg = pkgs.fetchurl {
    url = codexDmgUrl;
    hash = "sha256-TukDFPYFaGI+WE63hQuBc3d307761tMCi9+oco6sImU=";
  };
  currentCodexDmg = pkgs.fetchurl {
    url = codexDmgUrl;
    hash = "sha256-b2evfi+TQJOriv687BE3TUDI24+RAPtmIPJBVUAdgxk=";
  };
  replaceStaleCodexDmg =
    phase:
    let
      replacedPhase = builtins.replaceStrings [ "${staleCodexDmg}" ] [ "${currentCodexDmg}" ] phase;
      phaseContext = builtins.removeAttrs (builtins.getContext replacedPhase) [
        (builtins.unsafeDiscardStringContext staleCodexDmg.drvPath)
      ];
    in
    builtins.appendContext (builtins.unsafeDiscardStringContext replacedPhase) phaseContext;
  codexDesktopComputerUseUi =
    inputs.codex-desktop-linux.packages.${system}.codex-desktop-computer-use-ui.overrideAttrs
      (
        _finalAttrs: previousAttrs: {
          src = previousAttrs.src.overrideAttrs (
            _finalPayloadAttrs: previousPayloadAttrs: {
              installPhase = replaceStaleCodexDmg previousPayloadAttrs.installPhase;
            }
          );
        }
      );
in

{
  imports = [
    inputs.codex-desktop-linux.homeManagerModules.default
  ];

  programs.codexDesktopLinux = {
    enable = true;
    computerUseUi.enable = true;
    package = codexDesktopComputerUseUi;
  };
}
