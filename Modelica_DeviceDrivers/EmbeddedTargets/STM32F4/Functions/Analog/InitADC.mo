within Modelica_DeviceDrivers.EmbeddedTargets.STM32F4.Functions.Analog;

class InitADC
  extends ExternalObject;
import Modelica_DeviceDrivers.EmbeddedTargets.STM32F4.Functions.HAL;
function constructor "Initialize device"
  import Modelica_DeviceDrivers.EmbeddedTargets.STM32F4.Types;
  extends .Modelica.Icons.Function;
  input HAL.Init handle "handle";
  output InitADC hadc;
  external "C" hadc = MDD_stm32f4_adc_init(handle)
  annotation (Include="#include \"MDDSTM32F4Analog.h\"");
end constructor;

function destructor
  extends .Modelica.Icons.Function;
  input InitADC hadc;
  external "C" MDD_stm32f4_adc_close(hadc)
  annotation (Include="#include \"MDDSTM32F4Analog.h\"");
end destructor;
end InitADC;