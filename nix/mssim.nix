{pkgs}: {
    mssim = (with pkgs; stdenv.mkDerivation {
      name = "mssim";
      version = "0.1";
      src = fetchFromGitHub {
        owner = "microsoft";
        repo = "ms-tpm-20-ref";
        rev = "e9fc7b8";
        hash = "sha256-3+G+MNJqjs/j+Mtw5HlPPkzL8JXi6lvMnLX+pcCi1GA=
";
        };
        nativeBuildInputs = [ autoconf automake m4 pkg-config ];
        buildInputs = [openssl];
        configurePhase = ''
cd TPMCmd
patchShebangs bootstrap
./bootstrap
./configure
'';
        buildPhase = "make -j $NIX_BUILD_CORES";
    });
}
