ITI_ModelicaDeviceDrivers - Library wrapping most of the device driver interface functions into one SimulationX compatible dynamic link library.

SimulationX needs a DLL to interface to external C functions. Since this DLL also needs to link to a SimulationX specific "ModelicaExternalC.lib" in order to use functions from ModelicaUtilities.h, the generated DLL can only be used with SimulationX.

Therefore, this directory contains code to assemble such a SimulationX specific dynamic link library from the header-only files provided in ../../Include.

