within Modelica_DeviceDrivers.EmbeddedTargets.STM32F4.Functions.Digital;
function ledOut
  extends .Modelica.Icons.Function;
  input InitLed handle;
  input .Modelica_DeviceDrivers.EmbeddedTargets.STM32F4.Types.LED led "Led on board";
  input Boolean value;
  external "C" MDD_stm32f4_led_out(handle,led,value)
  annotation (Include="#include \"MDDSTM32F4Digital.h\"");
end ledOut;
