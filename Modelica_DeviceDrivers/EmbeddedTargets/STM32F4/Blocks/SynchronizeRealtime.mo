within Modelica_DeviceDrivers.EmbeddedTargets.STM32F4.Blocks;
block SynchronizeRealtime "A pseudo realtime synchronization"
  extends .Modelica_DeviceDrivers.Utilities.Icons.STM32F4BlockIcon;
  import SIunits =
         Modelica.Units.SI;
  import Modelica_DeviceDrivers.EmbeddedTargets.STM32F4.Constants;
  import Modelica_DeviceDrivers.EmbeddedTargets.STM32F4.Types;
  import Modelica_DeviceDrivers.EmbeddedTargets.STM32F4.Functions;
  import Modelica_DeviceDrivers.EmbeddedTargets.STM32F4.Functions.HAL;
  outer Microcontroller mcu;
  constant SIunits.Frequency desiredFrequency=mcu.desiredFrequency "Override the MCU global real-time settings" annotation(Dialog(
    enable = true,
    tab = "General",
    group = "Constants"));
  constant Types.Clock clock annotation(Dialog(
    enable = true,
    tab = "General",
    group = "Constants"));
  constant Types.PLLM pllM annotation(Dialog(
    enable = true,
    tab = "General",
    group = "Constants"));
  constant Types.PLLN pllN annotation(Dialog(
    enable = true,
    tab = "General",
    group = "Constants"));
  constant Types.PLLP pllP annotation(Dialog(
    enable = true,
    tab = "General",
    group = "Constants"));
  constant Types.PLLQ pllQ annotation(Dialog(
    enable = true,
    tab = "General",
    group = "Constants"));
  constant Types.AHBPre ahbPre annotation(Dialog(
    enable = true,
    tab = "General",
    group = "Constants"));
  constant Types.APBPre apb1Pre annotation(Dialog(
    enable = true,
    tab = "General",
    group = "Constants"));
  constant Types.APBPre apb2Pre annotation(Dialog(
    enable = true,
    tab = "General",
    group = "Constants"));
  constant Types.PWRRegulatorVoltage pwrRegVoltage annotation(Dialog(
    enable = true,
    tab = "General",
    group = "Constants"));
  constant Boolean overdrive annotation(Dialog(
    enable = true,
    tab = "General",
    group = "Constants"));
  constant Boolean preFlash annotation(Dialog(
    enable = true,
    tab = "General",
    group = "Constants"));
protected
  Functions.RealTimeSynchronization.Init sync =      Functions.RealTimeSynchronization.Init(mcu.hal, clock, pllM, pllN, pllP,pllQ, ahbPre, apb1Pre, apb2Pre, pwrRegVoltage, overdrive, preFlash);
  constant Integer desiredPeriod = if desiredFrequency == 0 then 0 else integer(floor(1000/desiredFrequency));
  Integer tick(start=0);//TODO should be HALGetTick
algorithm
  if not initial() then
    tick := tick +  desiredPeriod;
    Functions.RealTimeSynchronization.wait(sync, tick);
  end if;
  annotation(Icon(graphics={
        Bitmap(extent={{-58,-62},{62,58}}, fileName=
              "modelica://Modelica_DeviceDrivers/Resources/Images/Icons/clock.png"),
                                                                                  Text(extent={{
              -150,-110},{150,-150}},
          textString="%desiredFrequency Hz",
          textColor={0,0,0}),                                                     Text(extent={{
              -152,144},{148,104}},
            textString="%name")},                                                                                                            coordinateSystem(initialScale = 0.1)));
end SynchronizeRealtime;
