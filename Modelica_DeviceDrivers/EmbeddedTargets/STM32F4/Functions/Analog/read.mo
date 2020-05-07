within Modelica_DeviceDrivers.EmbeddedTargets.STM32F4.Functions.Analog;
function read
  extends .Modelica.Icons.Function;
  input InitADC hadc;
  input .Modelica_DeviceDrivers.EmbeddedTargets.STM32F4.Types.ADCChannel ch;
  output Integer v;
  external "C" v = MDD_stm32f4_analog_read(hadc,ch)
  annotation (Include="#include \"MDDSTM32F4Analog.h\"");
  annotation(__ModelicaAssociation_Impure=true);
end read;
