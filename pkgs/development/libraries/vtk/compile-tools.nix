{
  stdenv, lib, fetchFromGitLab,
  cmake
}:

stdenv.mkDerivation rec {
  pname = "vtk-compile-tools";
  version = "9.3.0";

  src = fetchFromGitLab {
    domain = "gitlab.kitware.com";
    owner  = "VTK";
    repo   = "VTK";
    rev    = "v${version}";
    sha256 = "sha256-wZHSW0DXx5uRYy6sPYc6t5b7rsLEDVYGM8f3rsEayfI=";
  };

  nativeBuildInputs = [ cmake ];

  cmakeFlags = [
    "-DVTK_BUILD_COMPILE_TOOLS_ONLY=ON"
    "-DCMAKE_INSTALL_LIBDIR=lib"
    "-DCMAKE_INSTALL_INCLUDEDIR=include"
    "-DCMAKE_INSTALL_BINDIR=bin"
    "-DVTK_VERSIONED_INSTALL=OFF"
  ];

  meta = with lib; {
    description = "Open source libraries for 3D computer graphics, image processing and visualization, with compile tools only";
    homepage = "https://www.vtk.org/";
    license = licenses.bsd3;
    maintainers = [ maintainers.cadkin ];
    platforms = platforms.all;
  };
}
