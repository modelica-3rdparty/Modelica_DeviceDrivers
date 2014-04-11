within Modelica_DeviceDrivers.HardwareIO;
class Comedi
  "Interface to the comedi (www.comedi.org), a linux control and measurement device library"
extends ExternalObject;

encapsulated function constructor "Open device"
    import Modelica_DeviceDrivers.HardwareIO.Comedi;
  input String devicename = "/dev/comedi0" "Device name";
  output Comedi comedi "File handle to comedi device";
  external "C" comedi = MDD_comedi_open(devicename)
  annotation (IncludeDirectory="modelica://Modelica_DeviceDrivers/Resources/Include",
    Include="#include \"MDDComedi.h\"",
    Library={"comedi"});
end constructor;

encapsulated function destructor "Close device"
    import Modelica_DeviceDrivers.HardwareIO.Comedi;
  input Comedi comedi "Device handle";
  external "C" MDD_comedi_close(comedi)
  annotation (IncludeDirectory="modelica://Modelica_DeviceDrivers/Resources/Include",
    Include="#include \"MDDComedi.h\"",
    Library={"comedi"});
end destructor;

end Comedi;
