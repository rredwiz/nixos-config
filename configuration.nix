{ pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./aliases.nix
  ];

  # automatically clean old versions
  nix.gc = {
    enable = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };
  boot.loader.grub.configurationLimit = 10; # limit grub to 10 iterations

  hardware.bluetooth.enable = true;

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.kernelPackages = pkgs.linuxPackages_latest;

  # custom daemon for disabling d3cold on for wifi adapter
  systemd.services.disable-iwlwifi-d3cold = {
    description = "Disable D3cold for Intel WiFi (0000:01:00.0)";
    wantedBy = [ "multi-user.target" ];

    # Provide tee/echo in PATH for the service script
    path = [ pkgs.coreutils ];

    serviceConfig = {
      Type = "oneshot";
    };

    # use tee for journalctl coverage and in case root privilages aren't default
    script = ''
      echo 0 | tee /sys/bus/pci/devices/0000:01:00.0/d3cold_allowed
    '';
  };

  services.tuned.enable = true;
  services.upower.enable = true;

  # enable noctalia calendar events
  services.gnome.evolution-data-server.enable = true;

  networking.hostName = "nixos";
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = true; # enables networking
  # networking.networkmanager.wifi.powersave = false;

  time.timeZone = "America/Halifax";
  i18n.defaultLocale = "en_CA.UTF-8";

  services.xserver = {
    enable = true;
    autoRepeatDelay = 200;
    autoRepeatInterval = 35;
  };

  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
    settings = {
      Autologin = {
        Session = "hyprland.desktop";
        User = "redwiz";
      };
    };
  };

  # make sure that wayland is used by default
  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  # ensures i have a portal enabled for screen sharing
  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
    config.common.default = [ "gtk" ];
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.redwiz = {
    isNormalUser = true;
    description = "andrew";
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
    shell = pkgs.zsh;
    # configured with home-manager
    # packages = with pkgs; [];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  programs.hyprland = {
    enable = true;
    portalPackage = pkgs.xdg-desktop-portal-hyprland;
  };
  programs.zsh.enable = true;

  environment.systemPackages = with pkgs; [
    vim
    wget
    stow
    git
    gh
  ];

  # set global environment variables
  environment.variables = {
    # XCURSOR_THEME = "Bibata-Modern-Ice";
    # XCURSOR_SIZE = "24";
    XCURSOR_THEME = "miku-cursor";
    XCURSOR_SIZE = "32";
  };

  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-color-emoji

    nerd-fonts.noto
    nerd-fonts.jetbrains-mono

    atkinson-hyperlegible

    vista-fonts
  ];

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  zramSwap = {
    enable = true;
    priority = 100;
    algorithm = "lz4";
    memoryPercent = 50;
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.11"; # Did you read the comment?
}
