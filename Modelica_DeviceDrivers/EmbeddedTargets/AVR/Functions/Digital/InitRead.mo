within Modelica_DeviceDrivers.EmbeddedTargets.AVR.Functions.Digital;
class InitRead
extends ExternalObject;
function constructor "Initialize device"
  import Modelica_DeviceDrivers.EmbeddedTargets.AVR.Types;
  extends .Modelica.Icons.Function;
  input Types.Port port "A digital port";
  input Types.Pin pin "A pin 1-8.";
  output InitRead dig;
  external "C" dig = MDD_avr_digital_pin_init(port,pin,false)
  annotation (Include="#include \"MDDAVRDigital.h\"");
end constructor;

function destructor
  extends .Modelica.Icons.Function;
  input InitRead digital;
  external "C" MDD_avr_digital_pin_close(digital)
  annotation (Include="#include \"MDDAVRDigital.h\"");
end destructor;
end InitRead;
