within Modelica_DeviceDrivers.EmbeddedTargets.AVR.Blocks;
model DigitalWriteBoolean
  extends .Modelica.Blocks.Interfaces.partialBooleanSI;
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
  Functions.Digital.InitWrite digital = Functions.Digital.InitWrite(port, pin);
algorithm
  Functions.Digital.write(digital, pin, u);
annotation(Icon(graphics={  Text(extent = {{-95, -95}, {95, 95}}, textString = "Digital %port%pin", fontName = "Arial")}));
end DigitalWriteBoolean;
