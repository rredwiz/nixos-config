{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
}:

stdenvNoCC.mkDerivation {
  pname = "frieren-linux-cursors";
  version = "0.0.1";

  src = fetchFromGitHub {
    owner = "rredwiz";
    repo = "frieren-linux-cursors";
    rev = "efa235699a1ceb791277383f2648f9da210df2ff";
    hash = lib.fakeHash;
  };

  installPhase = ''
    mkdir -p $out/share/icons/FrierenBLZ
    cp -r ./* $out/share/icons/FrierenBLZ/
  '';

  meta = with lib; {
    description = "Frieren BLZ cursor theme";
    homepage = "https://www.gnome-look.org/p/2355662";
    platforms = platforms.linux;
  };
}
