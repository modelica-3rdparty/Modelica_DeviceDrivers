within Modelica_DeviceDrivers.EmbeddedTargets.STM32F4.Blocks;
model DigitalWriteBoolean
  extends .Modelica.Blocks.Interfaces.partialBooleanSI;
  import Modelica_DeviceDrivers.EmbeddedTargets.STM32F4.Functions;
  import Modelica_DeviceDrivers.EmbeddedTargets.STM32F4.Functions.HAL;
  import Modelica_DeviceDrivers.EmbeddedTargets.STM32F4.Types;
  import Modelica.SIunits;
  constant HAL.Init port annotation(Dialog(
    enable = true,
    tab = "General",
    group = "Constants"));
  constant Types.Pin pin annotation(Dialog(
    enable = true,
    tab = "General",
    group = "Constants"));
protected
  Functions.Digital.InitWrite digital = Functions.Digital.InitWrite(port, pin);
algorithm
  Functions.Digital.write(digital, pin, u);
annotation(Icon(graphics = {Text(extent = {{-95, -95}, {95, 95}}, textString = "Digital %port%pin", fontName = "Arial")}));
end DigitalWriteBoolean;