{ pkgs }:

pkgs.stdenv.mkDerivation {
  pname = "doro-cursor";
  version = "0.0.1";

  src = pkgs.fetchFromGitHub {
    owner = "rredwiz";
    repo = "doro-linux-cursors";
    rev = "17ac0422b9614a0c5660993e570b1811a485a266";
    hash = "sha256-uwQ7SsxJZlBApFqWdUXn/CnONwWZomcKhSVspaLCqNo=";
  };

  installPhase = ''
    mkdir -p $out/share/icons/doro-cursor/
    cp -r * $out/share/icons/doro-cursor
  '';
}
