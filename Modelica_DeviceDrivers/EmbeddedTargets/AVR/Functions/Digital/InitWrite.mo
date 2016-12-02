within Modelica_DeviceDrivers.EmbeddedTargets.AVR.Functions.Digital;
model InitWrite
extends ExternalObject;
function constructor "Initialize device"
  import Modelica_DeviceDrivers.EmbeddedTargets.AVR.{Constants,Types};
  extends .Modelica.Icons.Function;
  input Types.Port port "A digital port";
  input Types.Pin pin "A pin 1-8.";
  output InitWrite dig;
  external "C" dig = MDD_avr_digital_pin_init(port,pin,true)
  annotation (Include="#include \"MDDAVRDigital.h\"");
end constructor;

function destructor
  extends .Modelica.Icons.Function;
  input InitWrite digital;
  external "C" MDD_avr_digital_pin_close(digital)
  annotation (Include="#include \"MDDAVRDigital.h\"");
end destructor;
end InitWrite;
