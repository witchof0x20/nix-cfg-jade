src: { stdenv, ... }:
stdenv.mkDerivation rec {
  name = "AutoEq";
  inherit src;
  buildPhase = "";
  installPhase = ''
    mkdir -p $out/share/autoeq/
    cp 'results/oratory1990/over-ear/Audio-Technica ATH-M50x (Massdrop velours earpads)/Audio-Technica ATH-M50x (Massdrop velours earpads) minimum phase 48000Hz.wav' $out/share/autoeq/ath-m50x-velour-48000.wav
    # HD 599 SE is the same headphone as the HD 599 (Amazon special edition colorway)
    cp 'results/oratory1990/over-ear/Sennheiser HD 599/Sennheiser HD 599 minimum phase 48000Hz.wav' $out/share/autoeq/hd-599-48000.wav
  '';

}
