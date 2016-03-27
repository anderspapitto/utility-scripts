{ stdenv, rustc }:

stdenv.mkDerivation {
  name = "nix-shell-wrapper";
  src = ./src;
  buildInputs = [ rustc ];

  buildPhase = ''
    rustc nix-shell-wrapper.rs
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp nix-shell-wrapper $out/bin/
  '';
}
