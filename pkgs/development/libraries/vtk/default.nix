{
  stdenv, lib, fetchFromGitLab,
  cmake, vtk-compile-tools,
  libGLU, libGL, libX11, xorgproto, libXt, libpng, libtiff, hdf5, sqlite,
  enableQt ? false, qtbase, qtdeclarative,
  enableOpenCascade ? false, opencascade-occt,
}:

stdenv.mkDerivation rec {
  pname = "vtk${lib.optionalString enableQt "-qt"}${lib.optionalString enableOpenCascade "-ioocct"}";
  version = "9.3.0";

  src = fetchFromGitLab {
    domain = "gitlab.kitware.com";
    owner  = "VTK";
    repo   = "VTK";
    rev    = "v${version}";
    sha256 = "sha256-wZHSW0DXx5uRYy6sPYc6t5b7rsLEDVYGM8f3rsEayfI=";
  };

  nativeBuildInputs = [
    cmake
    vtk-compile-tools
    sqlite
  ];

  propagatedBuildInputs = [
    libpng
    libtiff
  ];

  buildInputs = [
    hdf5
  ] ++ lib.optionals enableOpenCascade [
    opencascade-occt
  ] ++ lib.optionals enableQt [
    qtbase
    qtdeclarative
  ] ++ lib.optionals stdenv.isLinux [
    libGLU
    libGL
    xorgproto
    libXt
  ];

  cmakeFlags = [
    "-DCMAKE_C_FLAGS=-fPIC"
    "-DCMAKE_CXX_FLAGS=-fPIC"
    "-DCMAKE_INSTALL_LIBDIR=lib"
    "-DCMAKE_INSTALL_INCLUDEDIR=include"
    "-DCMAKE_INSTALL_BINDIR=bin"
    "-DVTK_VERSIONED_INSTALL=OFF"
    "-DVTK_MODULE_USE_EXTERNAL_VTK_png=ON"
    "-DVTK_MODULE_USE_EXTERNAL_VTK_tiff=ON"
    "-DVTK_MODULE_USE_EXTERNAL_VTK_hdf5=ON"
    "-DVTK_MODULE_USE_EXTERNAL_VTK_sqlite=ON"
    "-D_vtk_module_log=building"
  ] ++ lib.optionals stdenv.isLinux [
    "-DOPENGL_INCLUDE_DIR=${libGL.dev}/include"
  ] ++ lib.optionals stdenv.hostPlatform.isMinGW [
    "-DVTK_REQUIRE_LARGE_FILE_SUPPORT_EXITCODE=0"
  ] ++ lib.optionals enableQt [
    "-DVTK_GROUP_ENABLE_Qt:STRING=YES"
    "-DVTK_QT_VERSION=6"
    "-DVTK_MODULE_ENABLE_VTK_GUISupportQtQuick:STRING=NO"
  ] ++ lib.optionals enableOpenCascade [
    "-DVTK_MODULE_ENABLE_VTK_IOOCCT=YES"
  ];

  dontWrapQtApps = true;

  meta = with lib; {
    description = "Open source libraries for 3D computer graphics, image processing and visualization";
    homepage = "https://www.vtk.org/";
    license = licenses.bsd3;
    maintainers = [ maintainers.cadkin ];
    platforms = platforms.all;
  };
}
