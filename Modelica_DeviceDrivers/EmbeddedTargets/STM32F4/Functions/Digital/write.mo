within Modelica_DeviceDrivers.EmbeddedTargets.STM32F4.Functions.Digital;
function write
  extends .Modelica.Icons.Function;
  input InitWrite port;
  input .Modelica_DeviceDrivers.EmbeddedTargets.STM32F4.Types.Pin pin "Must correspond to the initialized port";
  input Boolean value;
  external "C" MDD_stm32f4_digital_pin_write(port,pin,value)
  annotation (Include="#include \"MDDSTM32F4Digital.h\"");
end write;
