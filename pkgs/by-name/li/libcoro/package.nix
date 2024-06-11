{
  lib, stdenv, fetchFromGitHub,
  cmake,
  openssl, c-ares,
  enableNetworking ? !stdenv.targetPlatform.isMinGW
}:

stdenv.mkDerivation rec {
  pname = "libcoro";
  version = "0.11.1";

  src = fetchFromGitHub {
    owner = "jbaldwin";
    repo = "libcoro";
    rev = "v${version}";
    sha256 = "sha256-TZ6EOS7Oo7ICXbx+ceQ6ZX18bPPWNwHyGJuALsUzb4s=";
  };

  patches = [
    ./0001-fix-libcoro-prefix.patch
  ];

  buildInputs = [
    openssl
    c-ares
  ];

  nativeBuildInputs = [
    cmake
  ];

  cmakeFlags = [
    "-DLIBCORO_EXTERNAL_DEPENDENCIES=ON"
    "-DLIBCORO_BUILD_SHARED_LIBS=ON"
    "-DLIBCORO_BUILD_EXAMPLES=OFF"
    "-DLIBCORO_BUILD_TESTS=OFF"
  ] ++ lib.optional (!enableNetworking) [
    "-DLIBCORO_FEATURE_NETWORKING=OFF"
    "-DLIBCORO_FEATURE_TLS=OFF"
  ];

  meta = {
    description = "C++20 coroutine library";
    longDescription = ''
       libcoro is meant to provide low level coroutine constructs for building
       larger applications, the current focus is around high performance
       networking coroutine support.
    '';
    homepage = "https://github.com/jbaldwin/libcoro";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.cadkin ];
    platforms = lib.platforms.all;
  };
}
