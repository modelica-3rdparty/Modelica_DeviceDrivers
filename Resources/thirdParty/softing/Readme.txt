Softing's CANL2 API (www.softing.com).

*THE DEVELOPMENT FILES IN THIS FOLDER MAY NOT BE DISTRIBUTED!*

The needed files are freely available from Softing, however the
corresponding license sets limits on the distributability of the
files. Consequently, the files are not distributed with this library.

There are exist drivers for Windows and Linux. However, the Linux package only supports very old Linux kernels (at least that was the case for June, 2012). Because of this, Softing CAN interfaces are currently only supported for Windows.


Please download and install the Softing drivers including the CAN Layer2 API from Softing
(e.g., start at http://industrial.softing.com/ and click your way through).

After installation of the software driver package available from Softing, please copy the files from
"$PATH_TO_SOFTING_API\APIDLL\*" into the directory of this Readme.txt (on my computer the Softing installation path
is "C:\Program Files (x86)\Softing\CAN\CAN Layer2 V5.16\APIDLL"),
so that you end up with the following directory tree:

.\win32\canL2.dll
.\win32\canL2.lib
.\win32\CANusbM.dll
.\win64\canL2_64.dll
.\win64\canL2_64.lib
.\win64\CANusbM.dll
.\Can_def.h
.\CANL2.h


Finally, note that in order to translate and execute Modelica models utilizing this API it is necessary that the
corresponding .lib and .dll files are found at compile and runtime. Prefered way to ensure this:

Copy the *.dll and *.lib for your architecture into your simulation directory (note that working on a 64bit Windows does not necessary mean that your Modelica tool compiles 64bit binaries, i.e., if in doubt just try both). Additionally, rename canL2_64.* to canL2.* if using the 64bit libraries.


