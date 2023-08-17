within Modelica_DeviceDrivers.EmbeddedTargets.STM32F4.Blocks;
block Microcontroller "Use as an inner block, defining the characteristics of the STM32F4 microcontroller"
  import SIunits =
         Modelica.Units.SI;
  import Modelica_DeviceDrivers;
  import Modelica_DeviceDrivers.EmbeddedTargets.STM32F4;
  import Modelica_DeviceDrivers.EmbeddedTargets.STM32F4.Constants;
  import Modelica_DeviceDrivers.EmbeddedTargets.STM32F4.Types;
  constant Types.Platform platform annotation(Dialog(
    enable = true,
    tab = "General",
    group = "Constants"));
/*  constant SIunits.Frequency cpuFrequency = Constants.cpuFrequency[platform] "Default frequency is the platform default (can be modified)" annotation(Dialog(
    enable = true,
    tab = "General",
    group = "Constants"));*/
  constant SIunits.Frequency desiredFrequency=if desiredPeriod==0 then 0 else (1/desiredPeriod) "the frequency the progam should be synchronized, if not expicit given, calculate from desiredPeriod" annotation(Dialog(
    enable = true,
    tab = "Real-time",
    group = "Constants"));
  constant SIunits.Time desiredPeriod=0 "Period the program should be synchronized, smaller than 1 ms (0.001) not supported" annotation(Dialog(
    enable = true,
    tab = "Real-time",
    group = "Constants"));
  STM32F4.Functions.HAL.Init hal = STM32F4.Functions.HAL.Init();
  annotation(missingInnerMessage = "Missing inner block for STM32F4 microcontroller (this cannot have default values since the microcontrollers are all different).",
             defaultComponentName="mcu",
             defaultComponentPrefixes="inner",
             Icon(graphics={  Text(origin={0,0},    textColor={255,255,255},     extent={{
              -66,-66},{66,66}},                                                                                                                                    fontName=
              "Arial",                                                                                                                                                                  textStyle=
              {TextStyle.Bold},
          textString="STM32F4
%platform"),
        Bitmap(extent={{-128,-112},{128,112}}, fileName=
              "modelica://Modelica_DeviceDrivers/Resources/Images/Icons/microcontroller_scheme.png"),
                              Text(textColor={0,0,0},           extent={{-86,
              -88},{86,74}},                                                                                                    fontName=
              "Arial",                                                                                                                              textStyle=
              {TextStyle.Bold},
          textString="AVR
%platform"),                                                                      Text(extent={{
              -154,158},{146,118}},
            textString="%name")},                                                                                                                                                                                  coordinateSystem(initialScale = 0.1)));
end Microcontroller;
