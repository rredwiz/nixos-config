{ pkgs, ... }:

let
  miku-cursor = pkgs.callPackage ./custom-builds/miku-cursor.nix { };
in
{
  imports = [ ./config/noctalia.nix ];

  programs.firefox.enable = true;
  programs.neovim.enable = true;
  programs.yazi.enable = true;

  home.packages = with pkgs; [

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
    ffmpeg-full
    intel-media-driver

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
    nixfmt
    stylua
    clojure
    clojure-lsp
    rust-analyzer

    # apps
    vesktop
    spotify
    # zed-editor-fhs

    # cosmetic
    bibata-cursors
    miku-cursor

    # terminal
    kitty
  ];

  home.stateVersion = "25.11";
}
