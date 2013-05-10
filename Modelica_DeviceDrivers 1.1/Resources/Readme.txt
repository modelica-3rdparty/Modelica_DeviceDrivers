*** C-SOURCES FOR THE Modelica_DeviceDrivers LIBRARY ***

If you want to compile the sources yourself the easiest way is to use
cmake (http://www.cmake.org/).

* GETTING CMAKE

Usually there will be a package
available from your linux distribution. E.g., for Debian/Ubuntu you would do:

aptitude install cmake

For MS Windows download it from http://www.cmake.org/

* BUILDING THE SOURCES

Check whether you need to build for 32bit on a native 64bit Linux architecture. If so,
use "CFLAGS=-m32 CXXFLAGS=-m32 cmake .." instead of "cmake ..". Dymola needs/needed that.
So, for Linux do:

mkdir build
cd build
cmake ..
make
make install

For MS Windows you can use the cmake GUI to setup a (MS Visual) project and do the build.

* THIRD-PARTY DEPENDENCIES

Some drivers might have a dependency to libraries or source code provided by
third parties (see folder "thirdParty").
These libraries/code may not be distributable by their licence
conditions. The build system tries to detect what is available and skips the rest. If you want/need
the functionality provided by the thirdParty libraries, get the respective libraries and include
them as described in "thirdParty" folder.

* GENERATE DOCUMENTATION USING DOXYGEN

Documentation generation using doxygen (http://www.stack.nl/~dimitri/doxygen/) is supported.

* ARTWORK AND ICONS

Some of the icons used in this library are derivatives/copies from artwork that
has been placed in the public domain by their respective authors.
The formidable work of these (public domain) authors is highly appreciated.
One particular valuable source for artwork was:
http://openclipart.org/
which uses the creative commons license CC0 1.0 Universal (CC0 1.0)
Public Domain Dedication: http://creativecommons.org/publicdomain/zero/1.0/

* CONTACT

Bernhard Thiele (bernhard.thiele@dlr.de)
Tobias Bellmann (tobias.bellmann@dlr.de)
