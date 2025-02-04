{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  hiredis,
  enableShared ? !stdenv.hostPlatform.isStatic,
  enableStatic ? stdenv.hostPlatform.isStatic,
}:

# You must build at one type of library
assert enableShared || enableStatic;

stdenv.mkDerivation rec {
  pname = "redis-plus-plus";
  version = "1.3.13";

  src = fetchFromGitHub {
    owner = "sewenew";
    repo = "redis-plus-plus";
    rev = version;
    sha256 = "sha256-bZxs1qnVAkh0BO0CyP1zL/+K3NZYmFy9ryg1QcRLcmg=";
  };

  patches = [
    ./0001-Fix-pkg-config-paths.patch
  ];

  nativeBuildInputs = [ cmake ];
  propagatedBuildInputs = [ hiredis ];

  cmakeFlags =
    [
      "-DREDIS_PLUS_PLUS_BUILD_TEST=OFF"
    ]
    ++ lib.optionals (!enableShared) [
      "-DREDIS_PLUS_PLUS_BUILD_SHARED=OFF"
    ]
    ++ lib.optionals (!enableStatic) [
      "-DREDIS_PLUS_PLUS_BUILD_STATIC=OFF"
    ];

  meta = with lib; {
    homepage = "https://github.com/sewenew/redis-plus-plus";
    description = "Redis client written in C++";
    license = licenses.asl20;
    platforms = platforms.unix;
    maintainers = with maintainers; [ wheelsandmetal ];
  };
}
