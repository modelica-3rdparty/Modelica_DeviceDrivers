within Modelica_DeviceDrivers.EmbeddedTargets.STM32F4.Functions.Analog;

function write
  extends .Modelica.Icons.Function;
  input InitDAC hdac;
  input Integer value;
  external "C" MDD_stm32f4_analog_write(hdac, value)
  annotation (Include="#include \"MDDSTM32F4Analog.h\"");
end write;