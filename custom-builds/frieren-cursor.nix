{ lib, stdenvNoCC, fetchzip }:

stdenvNoCC.mkDerivation {
  pname = "frieren-blz-cursor";
  version = "2026-04-13";

  src = fetchzip {
    # Replace this with the direct FrierenBLZ.zip download URL from the page.
    url = "https://PASTE_THE_REAL_FRIERENBLZ_ZIP_URL_HERE/FrierenBLZ.zip";
    hash = lib.fakeHash;
  };

  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/icons/FrierenBLZ
    cp -r ./* $out/share/icons/FrierenBLZ/

    runHook postInstall
  '';

  meta = with lib; {
    description = "Frieren BLZ cursor theme";
    homepage = "https://www.gnome-look.org/p/2355662";
    platforms = platforms.linux;
  };
}
