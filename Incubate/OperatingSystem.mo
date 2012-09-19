within Modelica_DeviceDrivers.Incubate;
package OperatingSystem
  class fileHandle "A filehandle for streaming data on the harddrive"
    extends Modelica_DeviceDrivers.Utilities.Icons.DriverIcon;
    extends Modelica_DeviceDrivers.Utilities.Icons.ObsoleteIcon;
    function openFileHandle
      input String filename "The filename, data is appended";
      output Integer fileHandle "The handle to the file";
    external"C" fileHandle = OS_openFileHandle(filename);
      annotation (Include="
#include <stdio.h>

FILE * OS_openFileHandle(const char * filename)
{
  FILE * pFile;
  pFile = fopen(filename,\"a\");
  return pFile;
}
void OS_writeString(int pFile, const char * string)
{
 if ((FILE *)pFile!=NULL)
  {
    fprintf((FILE *)pFile,\"%s\\n\",string);
  }
}
void OS_closeFileHandle(int pFile)
{
  if ((FILE *)pFile!=NULL)
  {
    fclose ((FILE *)pFile);
  }
}
");
    end openFileHandle;

    function closeFileHandle
      input Integer fileHandle "The handle to the file";
      external"C" OS_closeFileHandle(fileHandle);
    end closeFileHandle;

    function write
      input Integer fileHandle "The handle to the file";
      input String string "The string to be written into the file";
        external"C" OS_writeString(fileHandle, string);
    end write;
  end fileHandle;
end OperatingSystem;
