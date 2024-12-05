{ lib, swiftPackages, swift, swiftpm, swiftpm2nix, apple-sdk_11, ... }:

let
  # Pass the generated files to the helper.
  generated = swiftpm2nix.helpers ./nix;
in

swiftPackages.stdenv.mkDerivation {
  pname = "pam-watchid";
  version = "0.1.0";

  src = ./.;

  # Including SwiftPM as a nativeBuildInput provides a buildPhase for you.
  # This by default performs a release build using SwiftPM, essentially:
  #   swift build -c release
  nativeBuildInputs = [ swift swiftpm ];

  buildInputs = [ apple-sdk_11 ];

  # The helper provides a configure snippet that will prepare all dependencies
  # in the correct place, where SwiftPM expects them.
  # configurePhase = generated.configure;

  installPhase = ''
    # This is a special function that invokes swiftpm to find the location
    # of the binaries it produced.
    binPath="$(swiftpmBinPath)"
    # Now perform any installation steps.
    mkdir -p $out/lib
    cp $binPath/libpam_watchid.dylib $out/lib/pam_watchid.so
  '';
  
  meta = with lib; {
    platforms = platforms.darwin;
  };
}
