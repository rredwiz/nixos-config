{ inputs, ... }:

{
  imports = [
    inputs.codexDesktopLinux.homeManagerModules.default
  ];

  programs.codex-desktop-linux = {
    enable = true;
    computerUseUi.enable = true;
  };
}
