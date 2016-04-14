within Modelica_DeviceDrivers.Packaging;
package SerialPackager_ "Accompanying functions for the SerialPackager object"
  extends Modelica_DeviceDrivers.Utilities.Icons.DriverIcon;
encapsulated function addReal "Add Modelica Real encoded as double"
    import Modelica_DeviceDrivers.Packaging.SerialPackager;
    import Modelica_DeviceDrivers.Utilities.Types.ByteOrder;
  input SerialPackager pkg;
  input Real u[:];
  input ByteOrder byteOrder;
  external "C" MDD_SerialPackagerAddDouble(pkg, u, size(u,1), byteOrder)
  annotation(Include = "#include \"MDDSerialPackager.h\"",
             __iti_dll = "ITI_MDD.dll",
             __iti_dllNoExport = true);
end addReal;

encapsulated function addRealAsFloat
    "Add Modelica Real encoded as float (double is casted to float!)"
    import Modelica_DeviceDrivers.Packaging.SerialPackager;
    import Modelica_DeviceDrivers.Utilities.Types.ByteOrder;
  input SerialPackager pkg;
  input Real u[:];
  input ByteOrder byteOrder;
  external "C" MDD_SerialPackagerAddDoubleAsFloat(pkg, u, size(u,1), byteOrder)
  annotation(Include = "#include \"MDDSerialPackager.h\"",
             __iti_dll = "ITI_MDD.dll",
             __iti_dllNoExport = true);
end addRealAsFloat;

encapsulated function addInteger
    import Modelica_DeviceDrivers.Packaging.SerialPackager;
    import Modelica_DeviceDrivers.Utilities.Types.ByteOrder;
  input SerialPackager pkg;
  input Integer u[:];
  input ByteOrder byteOrder;
  external "C" MDD_SerialPackagerAddInteger(pkg, u, size(u,1), byteOrder)
  annotation(Include = "#include \"MDDSerialPackager.h\"",
             __iti_dll = "ITI_MDD.dll",
             __iti_dllNoExport = true);
end addInteger;

encapsulated function addString
    import Modelica_DeviceDrivers.Packaging.SerialPackager;
  input SerialPackager pkg;
  input String u;
  input Integer bufferSize;
  external "C" MDD_SerialPackagerAddString(pkg,u,bufferSize)
  annotation(Include = "#include \"MDDSerialPackager.h\"",
             __iti_dll = "ITI_MDD.dll",
             __iti_dllNoExport = true);
end addString;

encapsulated function addBoolean
    import Modelica_DeviceDrivers.Packaging.SerialPackager;
  input SerialPackager pkg;
  input Boolean u[:];
  external "C" MDD_SerialPackagerAddInteger(pkg, u, size(u,1))
  annotation(Include = "#include \"MDDSerialPackager.h\"",
             __iti_dll = "ITI_MDD.dll",
             __iti_dllNoExport = true);
end addBoolean;

encapsulated function setPos
    import Modelica_DeviceDrivers.Packaging.SerialPackager;
  input SerialPackager pkg;
  input Integer pos(min=0) "Set current byte position of package to pos";
  external "C" MDD_SerialPackagerSetPos(pkg, pos)
  annotation(Include = "#include \"MDDSerialPackager.h\"",
             __iti_dll = "ITI_MDD.dll",
             __iti_dllNoExport = true);
end setPos;

encapsulated function getPos
    import Modelica_DeviceDrivers.Packaging.SerialPackager;
  input SerialPackager pkg;
  output Integer pos(min=0) "Get current byte position of package";
  external "C" pos = MDD_SerialPackagerGetPos(pkg)
  annotation(Include = "#include \"MDDSerialPackager.h\"",
             __iti_dll = "ITI_MDD.dll",
             __iti_dllNoExport = true);
end getPos;

encapsulated function getReal
    import Modelica_DeviceDrivers.Packaging.SerialPackager;
    import Modelica_DeviceDrivers.Utilities.Types.ByteOrder;
  input SerialPackager pkg;
  input Integer n;
  input ByteOrder byteOrder;
  output Real y[n];
  external "C" MDD_SerialPackagerGetDouble(pkg,y,n,byteOrder)
  annotation(Include = "#include \"MDDSerialPackager.h\"",
             __iti_dll = "ITI_MDD.dll",
             __iti_dllNoExport = true);
end getReal;

encapsulated function getRealFromFloat
    "Get float from package (float is casted to double)"
    import Modelica_DeviceDrivers.Packaging.SerialPackager;
    import Modelica_DeviceDrivers.Utilities.Types.ByteOrder;
  input SerialPackager pkg;
  input Integer n;
  input ByteOrder byteOrder;
  output Real y[n];
  external "C" MDD_SerialPackagerGetFloatAsDouble(pkg,y,n,byteOrder)
  annotation(Include = "#include \"MDDSerialPackager.h\"",
             __iti_dll = "ITI_MDD.dll",
             __iti_dllNoExport = true);
end getRealFromFloat;

encapsulated function getInteger
    import Modelica_DeviceDrivers.Packaging.SerialPackager;
    import Modelica_DeviceDrivers.Utilities.Types.ByteOrder;
  input SerialPackager pkg;
  input Integer n;
  input ByteOrder byteOrder;
  output Integer y[n];
  external "C" MDD_SerialPackagerGetInteger(pkg,y,n,byteOrder)
  annotation(Include = "#include \"MDDSerialPackager.h\"",
             __iti_dll = "ITI_MDD.dll",
             __iti_dllNoExport = true);
end getInteger;

encapsulated function getString
    import Modelica_DeviceDrivers.Packaging.SerialPackager;
  input SerialPackager pkg;
  input Integer bufferSize;
  output String y;
  external "C" y = MDD_SerialPackagerGetString(pkg, bufferSize)
  annotation(Include = "#include \"MDDSerialPackager.h\"",
             __iti_dll = "ITI_MDD.dll",
             __iti_dllNoExport = true);
end getString;

encapsulated function getBoolean
    import Modelica_DeviceDrivers.Packaging.SerialPackager;
  input SerialPackager pkg;
  input Integer n;
  output Boolean y[n];
  external "C" MDD_SerialPackagerGetInteger(pkg,y,n)
  annotation(Include = "#include \"MDDSerialPackager.h\"",
             __iti_dll = "ITI_MDD.dll",
             __iti_dllNoExport = true);
end getBoolean;

encapsulated function resetPointer
    import Modelica_DeviceDrivers.Packaging.SerialPackager;
  input SerialPackager pkg;
  external "C" MDD_SerialPackagerSetPos(pkg, 0)
  annotation(Include = "#include \"MDDSerialPackager.h\"",
             __iti_dll = "ITI_MDD.dll",
             __iti_dllNoExport = true);
end resetPointer;

encapsulated function clear
    import Modelica_DeviceDrivers.Packaging.SerialPackager;
  input SerialPackager pkg;
  external "C" MDD_SerialPackagerClear(pkg)
  annotation(Include = "#include \"MDDSerialPackager.h\"",
             __iti_dll = "ITI_MDD.dll",
             __iti_dllNoExport = true);
end clear;

encapsulated function getBufferSize
    import Modelica_DeviceDrivers.Packaging.SerialPackager;
  input SerialPackager pkg;
  output Integer bufferSize;
  external "C" bufferSize = MDD_SerialPackagerGetSize(pkg)
  annotation(Include = "#include \"MDDSerialPackager.h\"",
             __iti_dll = "ITI_MDD.dll",
             __iti_dllNoExport = true);
end getBufferSize;

encapsulated function print "Print packager state information"
    import Modelica_DeviceDrivers.Packaging.SerialPackager;
  input SerialPackager pkg;
  external "C" MDD_SerialPackagerPrint(pkg)
  annotation(Include = "#include \"MDDSerialPackager.h\"",
             __iti_dll = "ITI_MDD.dll",
             __iti_dllNoExport = true);
end print;

encapsulated function integerBitUnpack
    "Unpack integer value encoded at bit level"
    import Modelica_DeviceDrivers.Packaging.SerialPackager;
  input SerialPackager pkg;
  input Integer bitOffset
      "Bit offset from current packager position until first encoding bit";
  input Integer width "Number of bits that encode the integer value";
  output Integer value "Decoded integer value";
  external "C" value = MDD_SerialPackagerIntegerBitunpack2(pkg, bitOffset, width)
  annotation(Include = "#include \"MDDSerialPackager.h\"",
             __iti_dll = "ITI_MDD.dll",
             __iti_dllNoExport = true);
end integerBitUnpack;

encapsulated function integerBitPack "Encode integer value at bit level"
    import Modelica_DeviceDrivers.Packaging.SerialPackager;
  input SerialPackager pkg;
  input Integer bitOffset
      "Bit offset from current packager position until first encoding bit";
  input Integer width "Number of bits that encode the integer value";
  input Integer value(min=0) "Value to encode in with bits";
  external "C" MDD_SerialPackagerIntegerBitpack2(pkg, bitOffset, width, value)
  annotation(Include = "#include \"MDDSerialPackager.h\"",
             __iti_dll = "ITI_MDD.dll",
             __iti_dllNoExport = true);
end integerBitPack;
end SerialPackager_;
