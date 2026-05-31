{ inputs, ... }:

{
  imports = [
    inputs.codex-desktop-linux.homeManagerModules.default
  ];

  programs.codex-desktop-linux = {
    enable = true;
    computerUseUi.enable = true;
  };
}
