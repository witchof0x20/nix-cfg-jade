{ stdenv, fetchFromGitHub, ... }:
stdenv.mkDerivation rec {
  name = "AutoEq";
  version = "git-2023-11-28";
  src = fetchFromGitHub {
    owner = "jaakkopasanen";
    repo = "AutoEq";
    rev = "0fad4b2ce4b3ceb97f0086c3a0940b4c2473c1f3";
    sha256 = "sha256-mKndkRgjwhj2RZ+cnjroqjiNZpPahK7G81H7Pvm6wAM=";
  };

  buildPhase = "";
  installPhase = ''
    mkdir -p $out/share/autoeq/
    cp 'results/oratory1990/over-ear/Audio-Technica ATH-M50x (Massdrop velours earpads)/Audio-Technica ATH-M50x (Massdrop velours earpads) minimum phase 48000Hz.wav' $out/share/autoeq/ath-m50x-velour-48000.wav
  '';

}
