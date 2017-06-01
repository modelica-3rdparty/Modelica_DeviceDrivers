within Modelica_DeviceDrivers.EmbeddedTargets.STM32F4.Functions.Digital;
function read
  extends .Modelica.Icons.Function;
  input InitRead port;
  input .Modelica_DeviceDrivers.EmbeddedTargets.STM32F4.Types.Pin pin "Must correspond to the initialized port";
  output Boolean b;
  external "C" b = MDD_avr_digital_pin_read(port,pin)
  annotation (Include="#include \"MDDSTM32F4Digital.h\"");
end read;
