{
  lib,
  fetchurl,
  stdenvNoCC,
  makeWrapper,
  jre,
}:

stdenvNoCC.mkDerivation rec {
  pname = "flix";
  version = "0.58.1";

  src = fetchurl {
    url = "https://github.com/flix/flix/releases/download/v${version}/flix.jar";
    sha256 = "sha256-YD0H6t5Qj6k8jUfjuMzgY3K2iAN+u4kvcjaqMANkrsw=";
  };

  dontUnpack = true;

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall

    export JAR=$out/share/java/flix/flix.jar
    install -D $src $JAR
    makeWrapper ${jre}/bin/java $out/bin/flix \
      --add-flags "-jar $JAR"

    runHook postInstall
  '';

  meta = with lib; {
    description = "Flix Programming Language";
    mainProgram = "flix";
    homepage = "https://github.com/flix/flix";
    sourceProvenance = with sourceTypes; [ binaryBytecode ];
    license = licenses.asl20;
    maintainers = with maintainers; [ athas ];
    inherit (jre.meta) platforms;
  };
}
