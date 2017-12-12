within Modelica_DeviceDrivers.EmbeddedTargets.STM32F4.Blocks;

block DAC
  import Modelica_DeviceDrivers.EmbeddedTargets.STM32F4;
  outer Microcontroller mcu;
  extends Modelica.Blocks.Icons.Block;
  //  TODO implement STM432F4 specific code

  Modelica.Blocks.Interfaces.IntegerInput u[size(timerNumbers,1)] "Connector of PWM input signals (integers 0..255)" annotation (
    Placement(transformation(extent={{-140,-20},{-100,20}})));
end DAC;