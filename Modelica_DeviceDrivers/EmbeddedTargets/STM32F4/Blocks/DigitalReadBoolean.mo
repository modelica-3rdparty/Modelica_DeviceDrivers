within Modelica_DeviceDrivers.EmbeddedTargets.STM32F4.Blocks;
model DigitalReadBoolean
  extends .Modelica.Blocks.Interfaces.partialBooleanSO;
  import Modelica_DeviceDrivers.EmbeddedTargets.STM32F4.Functions;
  import Modelica_DeviceDrivers.EmbeddedTargets.STM32F4.Types;
  import Modelica.SIunits;
  constant Types.Port port annotation(Dialog(
    enable = true,
    tab = "General",
    group = "Constants"));
  constant Types.Pin pin annotation(Dialog(
    enable = true,
    tab = "General",
    group = "Constants"));
protected
  Functions.Digital.InitRead digital = Functions.Digital.InitRead(port, pin);
equation
  y = Functions.Digital.read(digital, pin);
annotation(Icon(graphics = {Text(extent = {{-95, -95}, {95, 95}}, textString = "Digital %port%pin", fontName = "Arial")}));
end DigitalReadBoolean;