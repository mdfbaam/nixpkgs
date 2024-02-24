{ lib
, stdenv
, fetchFromGitHub
, cmake
, openssl
, c-ares
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

  nativeBuildInputs = [
    cmake
    openssl
    c-ares
  ];

  cmakeFlags = [
    "-DLIBCORO_EXTERNAL_DEPENDENCIES=ON"
    "-DLIBCORO_BUILD_SHARED_LIBS=ON"
    "-DLIBCORO_BUILD_EXAMPLES=OFF"
    "-DLIBCORO_BUILD_TESTS=OFF"
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
    platforms = lib.platforms.linux;
  };
}
