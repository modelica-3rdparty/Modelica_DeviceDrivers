within Modelica_DeviceDrivers.EmbeddedTargets.STM32F4.Blocks;
block SynchronizeRealtime "A pseudo realtime synchronization"
  import Modelica.SIunits;
  import Modelica_DeviceDrivers.EmbeddedTargets.STM32F4.Constants;
  import Modelica_DeviceDrivers.EmbeddedTargets.STM32F4.Types;
  import Modelica_DeviceDrivers.EmbeddedTargets.STM32F4.Functions;
  import Modelica_DeviceDrivers.EmbeddedTargets.STM32F4.Functions.HAL;
  outer Microcontroller mcu;
  constant SIunits.Frequency desiredFrequency=mcu.desiredFrequency "Override the MCU global real-time settings" annotation(Dialog(
    enable = true,
    tab = "General",
    group = "Constants"));
  constant HAL.Init hal;
   constant Types.TimerSelect timer annotation(Dialog(
    enable = true,
    tab = "General",
    group = "Constants"));
protected
  Functions.RealTimeSynchronization.Init sync =      Functions.RealTimeSynchronization.Init(hal);
  constant Integer desiredPeriod = integer(floor(1000/desiredFrequency)); //TODO check desiredFrequency = 0;
  Integer tick(start=0);//TODO should be HALGetTick
algorithm
  if not initial() then
    tick := tick +  desiredPeriod; 
    Functions.RealTimeSynchronization.wait(sync, tick);
    //while (HAL.GetTick(mcu.HALinit) <= tick) loop
    //end while;
  end if;
annotation(Icon(graphics = {Text(extent = {{-100, -100}, {100, 100}}, textString = "Real-time:\n%desiredFrequency Hz", fontName = "Arial")}, coordinateSystem(initialScale = 0.1)));
end SynchronizeRealtime;
