within Modelica_DeviceDrivers.EmbeddedTargets.STM32F4.Blocks;
model Led
  extends .Modelica_DeviceDrivers.Utilities.Icons.STM32F4BlockIcon;
  import Modelica_DeviceDrivers.EmbeddedTargets.STM32F4.Functions;
  import Modelica_DeviceDrivers.EmbeddedTargets.STM32F4.Functions.HAL;
  import Modelica_DeviceDrivers.EmbeddedTargets.STM32F4.Types;
  import SIunits =
         Modelica.Units.SI;
  constant HAL.Init handle annotation(Dialog(
    enable = true,
    tab = "General",
    group = "Constants"));
  constant Types.LED led annotation(Dialog(
    enable = true,
    tab = "General",
    group = "Constants"));
  outer Microcontroller mcu;
protected
  Functions.Digital.InitLed digital = Functions.Digital.InitLed(mcu.hal, led);
public
  Modelica.Blocks.Interfaces.BooleanInput u
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
algorithm
  Functions.Digital.ledOut(digital, u);
annotation(Icon(graphics={               Text(extent={{-150,144},{150,104}},
            textString="%name"),           Text(extent={{-218,-106},{226,-136}},
          textColor={0,0,0},
          textString="LED: %led"),
        Bitmap(origin = {-5, 1}, extent = {{-25, -65}, {33, 59}}, fileName=
              "modelica://Modelica_DeviceDrivers/Resources/Images/Icons/led-lamp-red-on.png")}));
end Led;
