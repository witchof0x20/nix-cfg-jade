{ stdenv, fetchFromGitHub, ... }:
stdenv.mkDerivation rec {
  name = "AutoEq";
  version = "git-2023-11-28";
  src = fetchFromGitHub {
    owner = "jaakkopasanen";
    repo = "AutoEq";
    rev = "0fad4b2ce4b3ceb97f0086c3a0940b4c2473c1f3";
    sha256 = "1mb3gfg01mj7ajjl1ylw24mnwamcnnibqyqw6rq";
  };

  buildPhase = "";
  # TODO:  also copy the massdrop velour earpad preset
  installPhase = ''
    mkdir -p $out/share/autoeq/
    cp ./results/oratory1990/over-ear/Audio-Technica\ ATH-M50x/Audio-Technica\ ATH-M50x\ minimum\ phase\ 48000Hz.wav $out/share/autoeq/ath-m50x-48000.wav
  '';

}
