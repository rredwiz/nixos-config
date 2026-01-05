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

    # utils
    hyprshot
    fastfetchMinimal
    unzipNLS
    brightnessctl
    playerctl
    tree
    htop
    btop
    cmatrix

    # development
    python315
    clang-tools
    clang
    ruff
    lua-language-server
    basedpyright
    nil
    quickshell
    alejandra
    stylua

    # apps
    vesktop
    spotify
    noctalia-shell # technically a shell, but gui
    zed-editor-fhs

    # cosmetic
    bibata-cursors
    miku-cursor

    # terminal
    kitty
  ];

  home.stateVersion = "25.11";
}
