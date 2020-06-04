within Modelica_DeviceDrivers.EmbeddedTargets.STM32F4.Blocks;
model DigitalWriteBoolean
  extends .Modelica.Blocks.Interfaces.partialBooleanSI;
  import Modelica_DeviceDrivers.EmbeddedTargets.STM32F4.Functions;
  import Modelica_DeviceDrivers.EmbeddedTargets.STM32F4.Functions.HAL;
  import Modelica_DeviceDrivers.EmbeddedTargets.STM32F4.Types;
  import SIunits =
         Modelica.Units.SI;
  constant Types.Port port annotation(Dialog(
    enable = true,
    tab = "General",
    group = "Constants"));
  constant Types.Pin pin annotation(Dialog(
    enable = true,
    tab = "General",
    group = "Constants"));
  outer Microcontroller mcu;
protected
  Functions.Digital.InitWrite digital = Functions.Digital.InitWrite(mcu.hal, port, pin);
algorithm
  Functions.Digital.write(digital, pin, u);
annotation(Icon(graphics={  Text(extent = {{-95, -95}, {95, 95}}, textString = "Digital %port%pin", fontName = "Arial")}));
end DigitalWriteBoolean;
