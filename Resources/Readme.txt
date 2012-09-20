* C-Sources for the Modelica_DeviceDrivers library *

If you want to compile the sources yourself the easiest way is to use
cmake (http://www.cmake.org/).

* Getting cmake

Usually there will be a package
available from your linux distribution. E.g. for Debian/Ubuntu you would do:

aptitude install cmake

For MS windows downlad it from http://www.cmake.org/

* Building the sources

cd ../Build
cmake ../Source
make
make install

* Third Party dependencies

Some drivers might have a dependency to libraries or source code provided by
third parties (see folder "thirdParty").
These libraries/code may not be distributable by their licence
conditions. If they are missing, please ensure yourself that you get them or
exclude the respective dependent drivers from the build process.

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
