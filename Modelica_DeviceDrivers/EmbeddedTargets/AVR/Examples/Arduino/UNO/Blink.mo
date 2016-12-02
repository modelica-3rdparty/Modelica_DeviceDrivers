within Modelica_DeviceDrivers.EmbeddedTargets.AVR.Examples.Arduino.UNO;
model Blink
  extends .Modelica.Icons.Example;
  import Modelica_DeviceDrivers.EmbeddedTargets.AVR;
  Boolean b(start=false, fixed=true);
  inner Modelica_DeviceDrivers.EmbeddedTargets.AVR.Blocks.Microcontroller mcu(desiredPeriod = 3, platform = Modelica_DeviceDrivers.EmbeddedTargets.AVR.Types.Platform.ATmega328P)
  annotation(Placement(visible = true, transformation(origin = {-67, 67}, extent = {{-23, -23}, {23, 23}}, rotation = 0)));
  AVR.Functions.Digital.InitWrite pinB5 = AVR.Functions.Digital.InitWrite(AVR.Types.Port.B, AVR.Types.Pin.'5');
  Modelica_DeviceDrivers.EmbeddedTargets.AVR.Blocks.SynchronizeRealtime synchronizeRealtime1(timer = Modelica_DeviceDrivers.EmbeddedTargets.AVR.Types.TimerSelect.Timer0)  annotation(Placement(visible = true, transformation(origin = {-4, 62}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
algorithm
  b := not pre(b);
  AVR.Functions.Digital.write(pinB5, AVR.Types.Pin.'5', b);
  annotation(/* synchronizeRealtime1.actualInterval is not legal in experiment annotation*/Experiment(Interval = 3), Documentation(info = "<html>
<h1>Blink</h1>
<p>Blink is a very simple Arduino model, which simply toggles the built-in LED on the board on and off at the given frequency. Use this model to see if your Modelica tool can export code for AVR MCUs.</p>
<p>Arduino digital pin 13 corresponds to digital pin B5 on the ATmega328P. If desired, you can connect an external LED to this PIN, with a suitable resistor in-between (perhaps 220&#8486;). Connect the other PIN on the LED to ground.</p>
<p>See also the <a href=\"https://www.arduino.cc/en/tutorial/blink\">Arduino tutorial</a> corresponding to this model.</p>
</html>"));
end Blink;