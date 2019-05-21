# C-sources for the Modelica_DeviceDrivers library

If you want to compile the sources yourself the easiest way is to use
CMake (http://www.cmake.org/).

## Getting CMake

Usually there will be a package
available from your linux distribution. E.g., for Debian/Ubuntu you would do:

```shell
aptitude install cmake
```

For MS Windows download it from http://www.cmake.org/

## Building the binaries

Check whether you need to build for 32bit on a native 64bit Linux architecture. If so,
use "CFLAGS=-m32 CXXFLAGS=-m32 cmake .." instead of "cmake ..".
So, for Linux do:

```shell
mkdir build
cd build
cmake ..
make
make install
```

For MS Windows you can use the CMake GUI to setup a (MS Visual Studio) project and do the build.

## Third-party dependencies

Some drivers might have a dependency to libraries or source code provided by
third parties (see folder "thirdParty").
These libraries/code may not be distributable by their license
conditions. The build system tries to detect what is available and skips the rest. If you want/need
the functionality provided by the thirdParty libraries, get the respective libraries and include
them as described in the "thirdParty" folder.

## Generate documentation using Doxygen

Documentation generation using doxygen (http://www.stack.nl/~dimitri/doxygen/) is supported.

## Artwork and icons

Some of the icons used in this library are derivatives/copies from artwork that
has been placed in the public domain by their respective authors.
The formidable work of these (public domain) authors is highly appreciated.
One particular valuable source for artwork was:
http://openclipart.org/
which uses the creative commons license CC0 1.0 Universal (CC0 1.0)
Public Domain Dedication: http://creativecommons.org/publicdomain/zero/1.0/

## Contact

- Bernhard Thiele (https://github.com/bernhard-thiele)
- Tobias Bellmann (https://github.com/tbellmann)
- Thomas Beutlich (https://github.com/beutlich)
