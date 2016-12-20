within Modelica_DeviceDrivers.EmbeddedTargets.AVR.Functions.Digital;
function read
  extends .Modelica.Icons.Function;
  input InitRead port;
  input .Modelica_DeviceDrivers.EmbeddedTargets.AVR.Types.Pin pin "Must correspond to the initialized port";
  output Boolean b;
  external "C" b = MDD_avr_digital_pin_read(port,pin)
  annotation (Include="#include \"MDDAVRDigital.h\"");
end read;
