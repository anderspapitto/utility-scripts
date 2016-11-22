{ stdenv, haskellPackages }:

stdenv.mkDerivation {
  name = "i3-focus";
  src = ./src;
  buildInputs = [ (haskellPackages.ghcWithPackages (p: with p; [ aeson text cabal-install utf8-string ])) ];

  configurePhase = ''
    export HOME=/tmp
  '';

  buildPhase = ''
    cabal build
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp dist/build/i3-focus/i3-focus $out/bin/
  '';
}
