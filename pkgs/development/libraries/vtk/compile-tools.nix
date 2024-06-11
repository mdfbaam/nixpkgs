{ majorVersion, minorVersion, sourceSha256, patchesToFetch ? [] }:
{ stdenv, lib, fetchurl, cmake, fetchpatch }:

let
  inherit (lib) optionalString optionals optional;

in stdenv.mkDerivation rec {
  pname = "vtk-compile-tools";
  version = "${majorVersion}.${minorVersion}";

  src = fetchurl {
    url = "https://www.vtk.org/files/release/${majorVersion}/VTK-${version}.tar.gz";
    sha256 = sourceSha256;
  };

  nativeBuildInputs = [ cmake ];

  cmakeFlags = [
    "-DVTK_BUILD_COMPILE_TOOLS_ONLY=ON"
    "-DCMAKE_INSTALL_LIBDIR=lib"
    "-DCMAKE_INSTALL_INCLUDEDIR=include"
    "-DCMAKE_INSTALL_BINDIR=bin"
    "-DVTK_VERSIONED_INSTALL=OFF"
  ];

  patches = map fetchpatch patchesToFetch;

  meta = with lib; {
    description = "Open source libraries for 3D computer graphics, image processing and visualization, with compile tools only";
    homepage = "https://www.vtk.org/";
    license = licenses.bsd3;
    maintainers = with maintainers; [ knedlsepp tfmoraes lheckemann ];
    #platforms = with platforms; unix;
  };
}
