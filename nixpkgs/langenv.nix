with import <nixpkgs> {};
let
  common = with pkgs; [
    cmake gnumake
    boost
    catch
    gdb
    libjpeg
    zlib
    readline
    netpbm
    doxygen
    valgrind
    openmpi
    rpm
    cimg
    pngpp
    clang-tools
  ];
  defaultPythonPackages = python3Packages;
  python-docx = callPackage ./python-docx.nix {
    pythonPackages = defaultPythonPackages;
  };
  opc-diag = callPackage ./opc-diag.nix {
    pythonPackages = defaultPythonPackages;
  };
  combine-docx = callPackage ./combine-docx.nix {
    pythonPackages = defaultPythonPackages;
    fetchFromGitHub = pkgs.fetchFromGitHub;
    inherit python-docx;
  };
  pandoc-crossref = pkgs.haskell.packages.ghc802.callPackage ./pandoc-crossref.nix { };
in rec {
  gccenv = stdenv.mkDerivation {
    name = "gccenv";
    src = ./.;
    hardeningDisable = [ "all" ];
    buildInputs = with pkgs; [
      gcc6
      ncurses
      SDL SDL_image
      opencv3
      gtest
      pkgconfig
      check
      libxml2
      ffmpeg
      bison
      flex
      cunit
      check
      amdappsdk
    ] ++ common;
  };

  clangenv = clangStdenv.mkDerivation {
    name = "clangenv";
    src = ./.;
    hardeningDisable = [ "all" ];
    buildInputs = with pkgs; [
      clang
    ] ++ common;
  };

  pythonenv = (defaultPythonPackages.python.buildEnv.override {
    extraLibs = with defaultPythonPackages; [
      matplotlib
      ipython
      scipy
      pyside
      virtualenv
      pillow
      tabulate
      readline
      sphinx
      docutils
      future
      sympy
      opencv3
      python-docx
    ];
  }).env;

  pandocenv = stdenv.mkDerivation {
    name = "pandocenv";
    src = ./.;
    buildInputs = with pkgs; [
      pandoc
      combine-docx
      opc-diag
      (import ./pandoc-eqnos/requirements.nix { }).packages.pandoc-eqnos
      (import ./pandoc-fignos/requirements.nix { }).packages.pandoc-fignos
      (import ./pandoc-tablenos/requirements.nix { }).packages.pandoc-tablenos
      pythonenv.buildInputs
      pandoc-crossref
    ];
  };

  latexenv = stdenv.mkDerivation {
    name = "latexenv";
    src = ./.;
    buildInputs = with pkgs; [
      cmake
      gnumake
      (texlive.combine {
        inherit (texlive) scheme-full metafont;
        pkgFilter = pkg: pkg.tlType == "run" || pkg.tlType == "bin" || pkg.pname == "core" || pkg.pname == "doc";
      })
      ghostscript
      poppler_utils
      biber
      gnome3.libgxps
      pythonenv.buildInputs
    ];
  };
}
