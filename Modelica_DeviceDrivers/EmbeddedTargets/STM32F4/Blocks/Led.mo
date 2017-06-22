within Modelica_DeviceDrivers.EmbeddedTargets.STM32F4.Blocks;
model Led
  extends .Modelica.Blocks.Interfaces.partialBooleanSI;
  import Modelica_DeviceDrivers.EmbeddedTargets.STM32F4.Functions;
  import Modelica_DeviceDrivers.EmbeddedTargets.STM32F4.Functions.HAL;
  import Modelica_DeviceDrivers.EmbeddedTargets.STM32F4.Types;
  import Modelica.SIunits;
  constant HAL.Init handle annotation(Dialog(
    enable = true,
    tab = "General",
    group = "Constants"));
  constant Types.LED led annotation(Dialog(
    enable = true,
    tab = "General",
    group = "Constants"));
protected
  Functions.Digital.InitLed digital = Functions.Digital.InitLed(handle, led);
algorithm
  Functions.Digital.ledOut(digital, led, u);
annotation(Icon(graphics = {Text(extent = {{-95, -95}, {95, 95}}, textString = "Digital %digital%led", fontName = "Arial")}));
end Led;