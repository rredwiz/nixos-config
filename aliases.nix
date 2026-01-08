{ pkgs, ... }:

{
  environment.systemPackages = [
    # opens a new tab in firefox on outlook
    (pkgs.writeShellScriptBin "outlook" ''
      ${pkgs.firefox}/bin/firefox --new-tab "https://outlook.office.com/mail/0/?deeplink=mail%2F0%2F"
    '')

    # opens a new tab in firefox on dal brightspace (university classwork homepage)
    (pkgs.writeShellScriptBin "brightspace" ''
      ${pkgs.firefox}/bin/firefox --new-tab "https://dal.brightspace.com/d2l/home"
    '')

    # opens nix search in a new firefox tab
    (pkgs.writeShellScriptBin "nixsearch" ''
      ${pkgs.firefox}/bin/firefox --new-tab "https://search.nixos.org/packages"
    '')
  ];
}
