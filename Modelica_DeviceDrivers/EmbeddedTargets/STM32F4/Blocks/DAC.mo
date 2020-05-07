within Modelica_DeviceDrivers.EmbeddedTargets.STM32F4.Blocks;

block DAC
  import Modelica_DeviceDrivers.EmbeddedTargets.STM32F4;
  import Modelica_DeviceDrivers.EmbeddedTargets.STM32F4.Functions;
  import Modelica_DeviceDrivers.EmbeddedTargets.FTM32F4.Types;
  import Modelica.SIunits;
  outer Microcontroller mcu;
  extends Modelica.Blocks.Icons.Block;
  //  TODO implement STM432F4 specific code

  Modelica.Blocks.Interfaces.IntegerInput pa4 "Connector of Analog DAC signal)" annotation (
    Placement(transformation(extent={{-140,-20},{-100,20}})));
protected
  Functions.Analog.InitDAC hdac = Functions.Analog.InitDAC(mcu.hal);
algorithm
  Functions.Analog.write(hdac, pa4);
annotation(Icon(graphics={  Text(extent = {{-95, -95}, {95, 95}}, textString = "Analog", fontName = "Arial")}));
end DAC;