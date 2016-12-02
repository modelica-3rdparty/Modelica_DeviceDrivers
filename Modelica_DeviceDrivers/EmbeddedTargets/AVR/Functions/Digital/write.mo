within Modelica_DeviceDrivers.EmbeddedTargets.AVR.Functions.Digital;
function write
  extends .Modelica.Icons.Function;
  input InitWrite port;
  input .Modelica_DeviceDrivers.EmbeddedTargets.AVR.Types.Pin pin "Must correspond to the initialized port";
  input Boolean value;
  external "C" MDD_avr_digital_pin_write(port,pin,value)
  annotation (Include="#include \"MDDAVRDigital.h\"");
end write;
