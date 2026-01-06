{ pkgs }:

pkgs.stdenv.mkDerivation {
  pname = "miku-cursor";
  version = "1.2.6";

  src = pkgs.fetchFromGitHub {
    owner = "supermariofps";
    repo = "hatsune-miku-windows-linux-cursors";
    rev = "471ff88156e9a3dc8542d23e8cae4e1c9de6e732";
    hash = "sha256-HCHo4GwWLvjjnKWNiHb156Z+NQqliqLX1T1qNxMEMfE=";
  };

  installPhase = ''
    mkdir -p $out/share/icons/miku-cursor/
    cp -r miku-cursor-linux/* $out/share/icons/miku-cursor
  '';
}
