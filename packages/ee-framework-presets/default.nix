src: { lib, stdenv, fetchFromGitHub, ... }:
stdenv.mkDerivation rec {
  inherit src;
  buildPhase = "";
  installPhase = ''
    mkdir -p $out/share/ee-framework-presets/
    cp *.json $out/share/ee-framework-presets
  '';
  meta = {
    description = "EasyEffects presets for the Framework laptop.";
    homepage = "https://github.com/ceiphr/ee-framework-presets";
    license = lib.licenses.mit;
  };

}
