within Modelica_DeviceDrivers.Communication.Packager;
class MinimalSerialPackager
 extends Modelica_DeviceDrivers.Utilities.Icons.PackagerIcon;
function constructMinimalSerialPackager
  input Integer bufferSize = 16 * 1024;
  output Integer msP;
  external "C" msP = MSP_createPackager(bufferSize);
  annotation(IncludeDirectory="modelica://Modelica_DeviceDrivers/Resources/Include",
           Include = "#include \"MDDMinimalSerialPackager.h\" ");
end constructMinimalSerialPackager;

function destructMinimalSerialPackager
  input Integer ssP;
  external "C" MSP_destroyPackager(ssP);
  annotation(IncludeDirectory="modelica://Modelica_DeviceDrivers/Resources/Include",
           Include = "#include \"MDDMinimalSerialPackager.h\" ");
end destructMinimalSerialPackager;

function addReal
  input Integer ssP;
  input Real u[:];
  external "C" MSP_addReal(ssP,u,size(u,1));
  annotation(IncludeDirectory="modelica://Modelica_DeviceDrivers/Resources/Include",
           Include = "#include \"MDDMinimalSerialPackager.h\" ");
end addReal;

function addInteger
  input Integer ssP;
  input Integer u[:];
  external "C" MSP_addInteger(ssP,u,size(u,1));
  annotation(IncludeDirectory="modelica://Modelica_DeviceDrivers/Resources/Include",
           Include = "#include \"MDDMinimalSerialPackager.h\" ");
end addInteger;

function addString
  input Integer ssP;
  input String u;
  external "C" MSP_addString(ssP,u);
  annotation(IncludeDirectory="modelica://Modelica_DeviceDrivers/Resources/Include",
           Include = "#include \"MDDMinimalSerialPackager.h\" ");
end addString;

function addBoolean
  input Integer ssP;
  input Boolean u[:];
  external "C" MSP_addInteger(ssP,u,size(u,1));
  annotation(IncludeDirectory="modelica://Modelica_DeviceDrivers/Resources/Include",
           Include = "#include \"MDDMinimalSerialPackager.h\" ");
end addBoolean;

function getPackage
  input Integer ssP;
  output String packagerData;
  external "C" packagerData = MSP_getPackage(ssP);
  annotation(IncludeDirectory="modelica://Modelica_DeviceDrivers/Resources/Include",
           Include = "#include \"MDDMinimalSerialPackager.h\" ");
end getPackage;

function setPackage
  input Integer ssP;
  input String packagerData;
  input Integer bufferSize;
  external "C" MSP_setPackage(ssP, packagerData, bufferSize);
  annotation(IncludeDirectory="modelica://Modelica_DeviceDrivers/Resources/Include",
           Include = "#include \"MDDMinimalSerialPackager.h\" ");
end setPackage;

function setPackage_SynchronousWorkaround
    "setPackage(..) with dummy return value. Needed in order to work with Dymola 2013 Synchronous Beta 3"
  input Integer ssP;
  input String packagerData;
  input Integer bufferSize;
  output Real dummy;
algorithm
  setPackage(ssP, packagerData, bufferSize);
  dummy :=3;
end setPackage_SynchronousWorkaround;

function getReal
  input Integer ssP;
  input Integer n;
  output Real y[n];
  external "C" MSP_getReal(ssP,y,n);
  annotation(IncludeDirectory="modelica://Modelica_DeviceDrivers/Resources/Include",
           Include = "#include \"MDDMinimalSerialPackager.h\" ");
end getReal;

function getInteger
  input Integer ssP;
  input Integer n;
  output Integer y[n];
  external "C" MSP_getInteger(ssP,y,n);
  annotation(IncludeDirectory="modelica://Modelica_DeviceDrivers/Resources/Include",
           Include = "#include \"MDDMinimalSerialPackager.h\" ");
end getInteger;

function getString
  input Integer ssP;
  output String y;
  external "C" y = MSP_getString(ssP);
  annotation(IncludeDirectory="modelica://Modelica_DeviceDrivers/Resources/Include",
           Include = "#include \"MDDMinimalSerialPackager.h\" ");
end getString;

function getBoolean
  input Integer ssP;
  input Integer n;
  output Boolean y[n];
  external "C" MSP_getInteger(ssP,y,n);
  annotation(IncludeDirectory="modelica://Modelica_DeviceDrivers/Resources/Include",
           Include = "#include \"MDDMinimalSerialPackager.h\" ");
end getBoolean;

function resetPointer
  input Integer ssP;
  external "C" MSP_resetPointer(ssP);
  annotation(IncludeDirectory="modelica://Modelica_DeviceDrivers/Resources/Include",
           Include = "#include \"MDDMinimalSerialPackager.h\" ");
end resetPointer;

function clear
  input Integer ssP;
  external "C" MSP_clear(ssP);
  annotation(IncludeDirectory="modelica://Modelica_DeviceDrivers/Resources/Include",
           Include = "#include \"MDDMinimalSerialPackager.h\" ");
end clear;

function getBufferSize
  input Integer ssP;
  output Integer bufferSize;
  external "C" bufferSize = MSP_getBufferSize(ssP);
  annotation(IncludeDirectory="modelica://Modelica_DeviceDrivers/Resources/Include",
           Include = "#include \"MDDMinimalSerialPackager.h\" ");
end getBufferSize;
end MinimalSerialPackager;
