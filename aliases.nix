{ pkgs, ... }:

{
    environment.systemPackages = [
        # opens a new tab in firefox on outlook
        (pkgs.writeShellScriptBin "outlook" ''
            ${pkgs.firefox}/bin/firefox --new-tab "https://outlook.office.com/mail/0/?deeplink=mail%2F0%2F"
        '')
    ];
}
