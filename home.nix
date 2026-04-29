{ pkgs, ... }:

let
  miku-cursor = pkgs.callPackage ./custom-builds/miku-cursor.nix { };
  doro-cursor = pkgs.callPackage ./custom-builds/doro-cursor.nix { };
  frieren-cursor = pkgs.callPackage ./custom-builds/frieren-cursor.nix { };
in
{
  imports = [ ./config/noctalia.nix ];

  programs.firefox.enable = true;
  programs.neovim = {
    enable = true;
    initLua = builtins.readFile ./nvim/init.lua;
    withPython3 = true;
    withNodeJs = true;
    withRuby = false;
  };
  programs.yazi.enable = true;
  programs.vesktop.enable = true;
  programs.vscode.enable = true;
  programs.obsidian.enable = true;

  home.pointerCursor = {
    gtk.enable = true;
    x11.enable = true;
    package = frieren-cursor;
    name = "FrierenBLZ";
    size = 32;
  };

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
    fzf
    ripgrep
    moonlight-qt # for remoting
    xhost # for x11 mirroring
    hyprcwd # for hyprland

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
    nodejs_24
    typescript-language-server
    gemini-cli-bin
    mysql-workbench
    glpk # for linear solve sail thingy
    docker
    flex
    codex

    # apps
    spotify

    # cosmetic
    bibata-cursors
    miku-cursor
    doro-cursor

    # terminal
    kitty
  ];

  home.stateVersion = "25.11";
}
