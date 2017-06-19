within Modelica_DeviceDrivers.EmbeddedTargets.STM32F4.Functions.Digital;
class InitWrite
extends ExternalObject;
import Modelica_DeviceDrivers.EmbeddedTargets.STM32F4.Functions.HAL;
function constructor "Initialize device"
  import Modelica_DeviceDrivers.EmbeddedTargets.STM32F4.Types;
  extends .Modelica.Icons.Function;
  input HAL.Init port "A digital port";
  input Types.Pin pin "A pin 1-8.";
  output InitWrite dig;
  external "C" dig = MDD_stm32f4_digital_pin_init(port,pin,true)
  annotation (Include="#include \"MDDSTM32F4Digital.h\"");
end constructor;

function destructor
  extends .Modelica.Icons.Function;
  input InitWrite digital;
  external "C" MDD_stm32f4_digital_pin_close(digital)
  annotation (Include="#include \"MDDSTM32F4Digital.h\"");
end destructor;
end InitWrite;
