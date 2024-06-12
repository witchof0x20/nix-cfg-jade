src: { stdenv, fetchFromGitHub, ... }:
stdenv.mkDerivation rec {
  inherit src;
  buildPhase = "";
  installPhase = ''
    mkdir -p $out/share/autoeq/
    cp 'results/oratory1990/over-ear/Audio-Technica ATH-M50x (Massdrop velours earpads)/Audio-Technica ATH-M50x (Massdrop velours earpads) minimum phase 48000Hz.wav' $out/share/autoeq/ath-m50x-velour-48000.wav
  '';

}
