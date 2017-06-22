within Modelica_DeviceDrivers.EmbeddedTargets.STM32F4.Functions.Digital;
class InitLed
extends ExternalObject;
import Modelica_DeviceDrivers.EmbeddedTargets.STM32F4.Functions.HAL;
function constructor "Initialize device"
  import Modelica_DeviceDrivers.EmbeddedTargets.STM32F4.Types;
  extends .Modelica.Icons.Function;
  input HAL.Init handle "handle";
  input Types.LED led "A led 3 to 6";
  output InitLed dig;
  external "C" dig = MDD_stm32f4_led_init(handle,led)
  annotation (Include="#include \"MDDSTM32F4Digital.h\"");
end constructor;

function destructor
  extends .Modelica.Icons.Function;
  input InitLed digital;
  external "C" MDD_stm32f4_led_close(digital)
  annotation (Include="#include \"MDDSTM32F4Digital.h\"");
end destructor;
end InitLed;
