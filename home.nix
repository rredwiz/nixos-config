{ pkgs, ... }:

let 
    miku-cursor = pkgs.callPackage ./custom-apps/miku-cursor.nix {};
in
{
  programs.firefox.enable = true;
  programs.neovim.enable = true;
  programs.yazi.enable = true;

  home.packages = with pkgs; [
    # swww
    # rofi
    # wlogout

    kitty
    hyprshot
    fastfetchMinimal
    vesktop
    unzipNLS
    python315
    brightnessctl
    spotify
    zed-editor-fhs
    clang-tools
    clang
    ruff
    lua-language-server
    basedpyright
    bibata-cursors
    miku-cursor
    quickshell
    noctalia-shell
    cmatrix
    playerctl
    nil
    tree
    htop
    btop
  ];

  home.stateVersion = "25.11";
}
