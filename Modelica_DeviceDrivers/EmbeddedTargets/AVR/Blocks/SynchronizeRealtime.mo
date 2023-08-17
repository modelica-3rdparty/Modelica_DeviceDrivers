within Modelica_DeviceDrivers.EmbeddedTargets.AVR.Blocks;
block SynchronizeRealtime "A pseudo realtime synchronization"
  import SIunits =
         Modelica.Units.SI;
  import Modelica_DeviceDrivers.EmbeddedTargets.AVR.Constants;
  import Modelica_DeviceDrivers.EmbeddedTargets.AVR.Types;
  import Modelica_DeviceDrivers.EmbeddedTargets.AVR.Functions;
  outer Microcontroller mcu;
  constant SIunits.Frequency desiredFrequency=mcu.desiredFrequency "Override the MCU global real-time settings" annotation(Dialog(
    enable = true,
    tab = "General",
    group = "Constants"));
  constant Real maxError = 0.01 "Used when calculating allowed clock parameters. 0.01=1% maximum error." annotation(Dialog(
    enable = true,
    tab = "General",
    group = "Constants"));
  constant Types.TimerSelect timer annotation(Dialog(
    enable = true,
    tab = "General",
    group = "Constants"));
  constant Types.TimerPrescaler prescaler = Functions.Utilities.reasonableClockSelect(mcu.cpuFrequency, desiredFrequency, maxError, prescalerConstants) "Pre-scaler for the clock." annotation(Dialog(
    enable = true,
    tab = "General",
    group = "Constants"));
  constant Integer count = Functions.Utilities.getClockCounterValue(mcu.cpuFrequency / prescalerConstants[prescaler], desiredFrequency, maxError) "The number of counts to be made. A value of 249 counts 250 steps." annotation(Dialog(
    enable = true,
    tab = "General",
    group = "Constants"));
  constant Integer iterations = div(integer(mcu.cpuFrequency / (desiredFrequency * prescalerConstants[prescaler])),(count+1)) "The number of times each interrupt should be executed." annotation(Dialog(
    enable = true,
    tab = "General",
    group = "Constants"));
  final parameter Real actualInterval = (prescalerConstants[prescaler] * (count+1) * iterations) / mcu.cpuFrequency;
protected
  constant SIunits.Frequency prescalerConstants[Types.TimerPrescaler] = Constants.prescalerTimer[mcu.platform, timer, :];
  Functions.Timers.Timer clock = Functions.Timers.Timer(timer, prescaler, clearTimerOnMatch=false);
  Functions.RealTimeSynchronization.Init sync = Functions.RealTimeSynchronization.Init(clock, count, iterations);
algorithm
  if not initial() then
    Functions.RealTimeSynchronization.wait(sync);
  end if;
annotation(Icon(graphics={  Text(extent = {{-100, -100}, {100, 100}}, textString = "Real-time:\n%desiredFrequency Hz", fontName = "Arial")}, coordinateSystem(initialScale = 0.1)));
end SynchronizeRealtime;
