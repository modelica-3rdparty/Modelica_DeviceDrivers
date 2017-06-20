within Modelica_DeviceDrivers.EmbeddedTargets.STM32F4.Examples.STM32F4_Discovery.Blink;
model Blink
  extends .Modelica.Icons.Example;
  import Modelica_DeviceDrivers.EmbeddedTargets.STM32F4;
  inner Modelica_DeviceDrivers.EmbeddedTargets.STM32F4.Blocks.Microcontroller mcu(desiredPeriod = 0.01, platform = Modelica_DeviceDrivers.EmbeddedTargets.STM32F4.Types.Platform.STM32DISC)
  annotation(Placement(visible = true, transformation(origin = {-67, 67}, extent = {{-23, -23}, {23, 23}}, rotation = 0)));
  STM32F4.Functions.HAL.Init HALinit = STM32F4.Functions.HAL.Init();
  Modelica_DeviceDrivers.EmbeddedTargets.STM32F4.Blocks.SynchronizeRealtime synchronizeRealtime1(timer = Modelica_DeviceDrivers.EmbeddedTargets.STM32F4.Types.TimerSelect.Timer0, hal = HALinit)  annotation(Placement(visible = true, transformation(origin = {-4, 62}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Blocks.DigitalWriteBoolean writeBool(pin = Modelica_DeviceDrivers.EmbeddedTargets.STM32F4.Types.Pin.'1', port = HALinit)  annotation(Placement(visible = true, transformation(origin = {24, 2}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.BooleanExpression booleanExpression1(y = mod(time, 1) >= 0.5)  annotation(Placement(visible = true, transformation(origin = {-26, 2}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  equation
  connect(booleanExpression1.y, writeBool.u) annotation(Line(points = {{-15, 2}, {12, 2}}, color = {255, 0, 255}));
  annotation(/* synchronizeRealtime1.actualInterval is not legal in experiment annotation*/Experiment(Interval = 0.01), Documentation(info = "<html>
<h1>Blink</h1>
<p>Blink is a very simple STM model, which simply toggles the built-in LED on the board on and off at the given frequency (this version blinks at a frequency given by the model using single precision floating point; it is also possible to simply flip the LED bit in each time step which gives a more accurate result). Use this model to see if your Modelica tool can export code for STM32F4 MCUs.</p>
<p>STM digital pin 13 corresponds to digital pin B5 on the ATmega328P. If desired, you can connect an external LED to this PIN, with a suitable resistor in-between (perhaps 220&#8486;). Connect the other PIN on the LED to ground.</p>
<p>See also the <a href=\"https://www.arduino.cc/en/tutorial/blink\">STM tutorial</a> corresponding to this model.</p>
</html>"));
end Blink;
