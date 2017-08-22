within Modelica_DeviceDrivers.EmbeddedTargets.STM32F4.Functions.Digital;
function ledOut
  extends .Modelica.Icons.Function;
  input InitLed handle;
  input Boolean value;
  external "C" MDD_stm32f4_led_out(handle,value)
  annotation (Include="#include \"MDDSTM32F4Digital.h\"");
end ledOut;
