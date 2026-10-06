{ lib, stdenvNoCC, fetchurl, fetchzip, autoPatchelfHook, stdenv, runCommand }:

let
  version = "0.28.4";
  source = fetchzip {
    url = "https://github.com/backnotprop/plannotator/archive/refs/tags/v${version}.tar.gz";
    hash = "sha256-8b2LDE4fmhKZM81Uk8B9NpMzPpR+86wwkyWtCpMegGU=";
  };
in
stdenvNoCC.mkDerivation {
  pname = "plannotator";
  inherit version;

  src = fetchurl {
    url = "https://github.com/backnotprop/plannotator/releases/download/v${version}/plannotator-linux-x64";
    hash = "sha256-5Ye2L6fIT0+vRBc4g6AJCZiNQuHhViPSh/cnbZgEY2A=";
  };

  nativeBuildInputs = [ autoPatchelfHook ];
  buildInputs = [ stdenv.cc.cc.lib ];
  dontUnpack = true;
  dontConfigure = true;
  dontBuild = true;
  # The release binary embeds its application; preserve the embedded payload.
  dontStrip = true;

  installPhase = ''
    runHook preInstall
    install -Dm755 "$src" "$out/bin/plannotator"
    runHook postInstall
  '';

  passthru.skills = runCommand "plannotator-skills-${version}" { } ''
    mkdir -p "$out/share/plannotator/skills"
    cp -R ${source}/apps/skills/core/. "$out/share/plannotator/skills/"
  '';

  meta = {
    description = "Browser-based plan annotation and code review for AI coding agents";
    homepage = "https://plannotator.ai";
    license = with lib.licenses; [ mit asl20 ];
    mainProgram = "plannotator";
    platforms = [ "x86_64-linux" ];
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
  };
}
