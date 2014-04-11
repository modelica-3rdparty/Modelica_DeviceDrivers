DLLWrapper library - Library wrapping most of the device driver interface functions into one dynamic link library.

Most of the time external C code is directly "injected" into the Modelica library by just including C headers that already contain all the source code (header-only style).

However, this approach is not supported by all tools. Some tools need to load an DLL which provides the respective functions.

Therefore, this directory contains code to assemble such a dynamic link library from the header-only files.

