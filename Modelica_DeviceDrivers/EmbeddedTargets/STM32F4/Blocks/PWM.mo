within Modelica_DeviceDrivers.EmbeddedTargets.STM32F4.Blocks;
model PWM
  import Modelica_DeviceDrivers.EmbeddedTargets.STM32F4;
  outer Microcontroller mcu;
  extends Modelica.Blocks.Icons.Block;
  constant Boolean fastPWM=false annotation(Dialog(
    enable = true,
    tab = "General",
    group = "Constants"));
  constant STM32F4.Types.TimerSelect timer annotation(Dialog(
    enable = true,
    tab = "General",
    group = "Constants"));
  constant STM32F4.Types.TimerPrescaler prescaler "Pre-scaler for the clock." annotation(Dialog(
    enable = true,
    tab = "General",
    group = "Constants"));
  constant STM32F4.Types.TimerNumber timerNumbers[:] "Which PWM outputs on the associated timer should be used (usually {A}, {B}, or {A,B})" annotation(Dialog(
    enable = true,
    tab = "General",
    group = "Constants"));
  constant Integer initialValues[size(timerNumbers,1)]=fill(0, size(timerNumbers,1)) "The value that is used to initialize the PWM before the first call to PWM.set" annotation(Dialog(
    enable = true,
    tab = "General",
    group = "Constants"));
  Modelica.Blocks.Interfaces.IntegerInput u[size(timerNumbers,1)] "Connector of PWM input signals (integers 0..255)" annotation (
    Placement(transformation(extent={{-140,-20},{-100,20}})));
protected
  STM32F4.Functions.Timers.Timer clock = STM32F4.Functions.Timers.Timer(timer, prescaler, clearTimerOnMatch=fastPWM);
  STM32F4.Functions.PWM.Init pwm[:] = {STM32F4.Functions.PWM.Init(clock, timerNumbers[i], initialValues[i]) for i in 1:size(timerNumbers,1)};
equation
  for i in 1:size(timerNumbers,1) loop
    STM32F4.Functions.PWM.set(pwm[i], u[i]);
   end for;
  annotation(defaultComponentName = "pwm", Icon(graphics = {Text(extent = {{-95, -95}, {95, 95}}, textString = "PWM %timer\n%timerNumbers", fontName = "Arial")}));
end PWM;