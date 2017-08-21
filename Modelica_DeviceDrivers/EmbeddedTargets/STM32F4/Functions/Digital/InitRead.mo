within Modelica_DeviceDrivers.EmbeddedTargets.STM32F4.Functions.Digital;
class InitRead
extends ExternalObject;
import Modelica_DeviceDrivers.EmbeddedTargets.STM32F4.Functions.HAL;
function constructor "Initialize device"
  import Modelica_DeviceDrivers.EmbeddedTargets.STM32F4.Types;
  extends .Modelica.Icons.Function;
  input HAL.Init handle "handle of HAL init";
  input Types.Port port "A digital port A-I";
  input Types.Pin pin "A pin 0-15, ALL";
  output InitRead dig;
  external "C" dig = MDD_stm32f4_digital_pin_init(handle, port, pin, false)
  annotation (Include="#include \"MDDSTM32F4Digital.h\"");
end constructor;

function destructor
  extends .Modelica.Icons.Function;
  input InitRead digital;
  external "C" MDD_stm32f4_digital_pin_close(digital)
  annotation (Include="#include \"MDDSTM32F4Digital.h\"");
end destructor;
end InitRead;
