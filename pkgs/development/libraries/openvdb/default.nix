{ lib, stdenv, fetchFromGitHub, cmake, boost, jemalloc, c-blosc, tbb, zlib, bzip2, lzma, zstd}:

stdenv.mkDerivation rec
{
  pname = "openvdb";
  version = "11.0.0";

  outputs = [ "out" "dev" ];

  src = fetchFromGitHub {
    owner = "AcademySoftwareFoundation";
    repo = "openvdb";
    rev = "v${version}";
    sha256 = "sha256-wDDjX0nKZ4/DIbEX33PoxR43dJDj2NF3fm+Egug62GQ=";
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = [ boost tbb jemalloc c-blosc zlib ] ++ lib.optionals stdenv.hostPlatform.isMinGW [
    bzip2
    lzma
    zstd
  ];

  cmakeFlags = [
    "-DOPENVDB_BUILD_NANOVDB=ON"
  ] ++ lib.optionals stdenv.hostPlatform.isMinGW [
    "-DOPENVDB_CORE_STATIC=ON"
    "-DOPENVDB_CORE_SHARED=OFF"
    "-DBoost_USE_STATIC_LIBS=ON"
  ] ++ lib.optionals stdenv.hostPlatform.isUnix [
    "-DOPENVDB_CORE_STATIC=OFF"
    "-DOPENVDB_CORE_SHARED=ON"
  ];

  # error: aligned deallocation function of type 'void (void *, std::align_val_t) noexcept' is only available on macOS 10.13 or newer
  NIX_CFLAGS_COMPILE = lib.optionals (stdenv.isDarwin && lib.versionOlder stdenv.hostPlatform.darwinMinVersion "10.13" && lib.versionAtLeast tbb.version "2021.8.0") [
    "-faligned-allocation"
  ] ++ lib.optionals stdenv.hostPlatform.isMinGW [
    "-Wa,-mbig-obj"
  ];

  postFixup = ''
    substituteInPlace $dev/lib/cmake/OpenVDB/FindOpenVDB.cmake \
      --replace \''${OPENVDB_LIBRARYDIR} $out/lib \
      --replace \''${OPENVDB_INCLUDEDIR} $dev/include

    cp ${./openvdb-config.cmake} $dev/lib/cmake/OpenVDB/openvdb-config.cmake
  '';

  meta = with lib; {
    description = "Open framework for voxel";
    mainProgram = "vdb_print";
    homepage = "https://www.openvdb.org";
    maintainers = [ maintainers.guibou ];
    platforms = platforms.all;
    license = licenses.mpl20;
  };
}
