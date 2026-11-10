# Note that this script can accept some limited command-line arguments, run
# `julia build_tarballs.jl --help` to see a usage message.
#
# DAQP built from the branch dyad of JuliaComputing/daqp (DAQP master with the changes that are not
# yet released), as the library of the Julia package DyadDAQP. Besides the library and the headers,
# the C sources are installed into share/daqp/src, from which the code generation of DyadDAQP copies
# them, so that generated code matches the library that rendered the workspace.
using BinaryBuilder, Pkg

name = "DyadDAQP"
version = v"0.11.1"

# Collection of sources required to complete build
sources = [
    GitSource("https://github.com/JuliaComputing/daqp.git", "86305bd236f55bd0089828ff4909bd3a685bd3c4")
]

# Bash recipe for building across all platforms
script = raw"""
cd $WORKSPACE/srcdir/daqp
mkdir build
cd build
cmake -DCMAKE_INSTALL_PREFIX=${prefix} \
    -DCMAKE_TOOLCHAIN_FILE=${CMAKE_TARGET_TOOLCHAIN} \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_C_FLAGS="-std=gnu11" \
    ..
make -j${nproc}
make install
install -Dm644 -t ${prefix}/share/daqp/src ../src/*.c
install_license ../LICENSE
"""

# These are the platforms we will build for by default, unless further
# platforms are passed in on the command line
platforms = supported_platforms()

# The products that we will ensure are always built
products = [
    LibraryProduct("libdaqp", :libdaqp)
]

# Dependencies that must be installed before this package can be built
dependencies = Dependency[
]

# Build the tarballs, and possibly a `build.jl` as well.
# The parallel branch and bound (CMake option PARALLEL, daqp_solve_parallel) uses C11 atomics and threads:
# the default GCC of BinaryBuilder (4.8) has no stdatomic.h, with which the library is built without it.
# GCC 10 is the version with which the build was verified on armv6l, armv7l and i686.
build_tarballs(ARGS, name, version, sources, script, platforms, products, dependencies; julia_compat="1.6",
               preferred_gcc_version=v"10")
