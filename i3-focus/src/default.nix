{ mkDerivation, aeson, base, bytestring, process, stdenv, text
, utf8-string
}:
mkDerivation {
  pname = "i3-focus";
  version = "0.1.0.0";
  src = ./.;
  isLibrary = false;
  isExecutable = true;
  executableHaskellDepends = [
    aeson base bytestring process text utf8-string
  ];
  license = stdenv.lib.licenses.bsd3;
}
