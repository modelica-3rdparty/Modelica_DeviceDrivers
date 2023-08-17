within Modelica_DeviceDrivers.EmbeddedTargets.AVR.Blocks;
model DigitalReadBoolean
  extends .Modelica.Blocks.Interfaces.partialBooleanSO;
  import Modelica_DeviceDrivers.EmbeddedTargets.AVR.Functions;
  import Modelica_DeviceDrivers.EmbeddedTargets.AVR.Types;
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
protected
  Functions.Digital.InitRead digital = Functions.Digital.InitRead(port, pin);
algorithm
  y := Functions.Digital.read(digital, pin);
annotation(Icon(graphics={  Text(extent = {{-95, -95}, {95, 95}}, textString = "Digital %port%pin", fontName = "Arial")}));
end DigitalReadBoolean;
