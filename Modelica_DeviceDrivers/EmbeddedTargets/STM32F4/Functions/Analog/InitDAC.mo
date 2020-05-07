within Modelica_DeviceDrivers.EmbeddedTargets.STM32F4.Functions.Analog;

class InitDAC
  extends ExternalObject;
import Modelica_DeviceDrivers.EmbeddedTargets.STM32F4.Functions.HAL;
function constructor "Initialize device"
  import Modelica_DeviceDrivers.EmbeddedTargets.STM32F4.Types;
  extends .Modelica.Icons.Function;
  input HAL.Init handle "handle";
  output InitDAC hdac;
  external "C" hdac = MDD_stm32f4_dac_init(handle)
  annotation (Include="#include \"MDDSTM32F4Analog.h\"");
end constructor;

function destructor
  extends .Modelica.Icons.Function;
  input InitDAC hdac;
  external "C" MDD_stm32f4_dac_close(hdac)
  annotation (Include="#include \"MDDSTM32F4Analog.h\"");
end destructor;
end InitDAC;