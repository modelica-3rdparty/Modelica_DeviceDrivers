within Modelica_DeviceDrivers.EmbeddedTargets.STM32F4.Functions.Digital;
class InitExtInt
extends ExternalObject;
import Modelica_DeviceDrivers.EmbeddedTargets.STM32F4.Functions.HAL;
function constructor "Initialize device"
  import Modelica_DeviceDrivers.EmbeddedTargets.STM32F4.Types;
  extends .Modelica.Icons.Function;
  input HAL.Init handle "handle of HAL init";
  input Types.Port port "A digital port A-I";
  input Types.Pin pin "A pin 0-15, ALL";
  input Types.Mode mode "interrupt on rising, falling, rising and falling edge";
  input Types.Prio preemptPrio "preemption priority for interrupt";
  input Types.Prio subPrio "sub priority for interrupt";
  output InitExtInt hport;
  external "C" hport = MDD_stm32f4_exti_pin_init(handle, port, pin, mode, preemptPrio, subPrio)
  annotation (Include="#include \"MDDSTM32F4Digital.h\"");
end constructor;

function destructor
  extends .Modelica.Icons.Function;
  input InitExtInt port;
  external "C" MDD_stm32f4_exti_pin_close(port)
  annotation (Include="#include \"MDDSTM32F4Digital.h\"");
end destructor;
end InitExtInt;
