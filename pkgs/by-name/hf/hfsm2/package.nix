{
  lib, stdenv, fetchFromGitHub,
  cmake
}:

stdenv.mkDerivation rec {
  pname = "hfsm2";
  version = "2.5.1";

  src = fetchFromGitHub {
    owner = "andrew-gresyk";
    repo = "HFSM2";
    rev = "${version}";
    sha256 = "sha256-aa0VvFFW63Q5Y2AD4qBNrPUBMDwrA7VWPaDz6+5bvn8=";
  };

  patches = [
    ./0001-install.patch
  ];

  nativeBuildInputs = [
    cmake
  ];

  meta = {
    description = "High-Performance Hierarchical Finite State Machine";
    longDescription = ''
       Header-only heriarchical FSM framework in C++11, with fully
       statically-defined structure (no dynamic allocations), built with
       variadic templates. '';
    homepage = "https://github.com/andrew-gresyk/HFSM2";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.cadkin ];
    platforms = lib.platforms.all;
  };
}
