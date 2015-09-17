within Modelica_DeviceDrivers.Packaging;
class SerialPackager "Serial packaging of data"
 extends ExternalObject;

encapsulated function constructor "Claim the memory"
    import Modelica_DeviceDrivers.Packaging.SerialPackager;
  input Integer bufferSize = 16 * 1024;
  output SerialPackager pkg;
  external "C" pkg = MDD_SerialPackagerConstructor(bufferSize)
  annotation(Include = "#include \"MDDSerialPackager.h\" ",
             __iti_dll = "ITI_MDD.dll",
             __iti_dllNoExport = true);
end constructor;

encapsulated function destructor "Free memory"
    import Modelica_DeviceDrivers.Packaging.SerialPackager;
  input SerialPackager pkg;
  external "C" MDD_SerialPackagerDestructor(pkg)
  annotation(Include = "#include \"MDDSerialPackager.h\" ",
             __iti_dll = "ITI_MDD.dll",
             __iti_dllNoExport = true);
end destructor;

end SerialPackager;
