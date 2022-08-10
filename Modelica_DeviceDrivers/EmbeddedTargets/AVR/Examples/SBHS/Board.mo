within Modelica_DeviceDrivers.EmbeddedTargets.AVR.Examples.SBHS;
model Board "Base SBHS board"
  extends Modelica.Blocks.Icons.Block;
  import Modelica_DeviceDrivers.EmbeddedTargets.AVR;
  import Modelica_DeviceDrivers.EmbeddedTargets.AVR.Blocks;
  import Modelica_DeviceDrivers.EmbeddedTargets.AVR.Functions.Digital.LCD.HD44780;
  import Modelica_DeviceDrivers.EmbeddedTargets.AVR.Functions;

  import Modelica_DeviceDrivers.Utilities.Types.SerialBaudRate;

  Modelica.Blocks.Interfaces.IntegerInput fan "Connector of fan PWM input signal (Integer 0..255)" annotation (
    Placement(visible = true, transformation(extent = {{-140, 18}, {-100, 58}}, rotation = 0), iconTransformation(extent = {{-140, 26}, {-100, 66}}, rotation = 0)));
  Modelica.Blocks.Interfaces.IntegerInput heat "Connector of fan PWM input signal (Integer 0..255)" annotation (
    Placement(visible = true, transformation(extent = {{-140, -62}, {-100, -22}}, rotation = 0), iconTransformation(extent = {{-140, -60}, {-100, -20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput degC(final unit="degC") "Connector of temperature sensor output in degC" annotation (Placement(
        transformation(extent={{100,-10},{120,10}})));

  Functions.SerialPort.Init serial = Functions.SerialPort.Init(SerialBaudRate.B38400);
  Functions.SerialPort.MapStandardIO io = Functions.SerialPort.MapStandardIO(serial, stdin=false, stdout=true);

  import Modelica.Units.SI.Voltage;
  import Modelica.Units.NonSI.Temperature_degC;

  HD44780.Init lcd = HD44780.Init(AVR.Types.Port.C,"TEMP TIME    FAN0123456789ABCDEF");

  Integer i10=integer(mod(degC/10,10));
  Integer i1=integer(mod(degC,10));
  Integer d1=integer(mod(degC*10,10));
  constant Integer '0'=48,'.'=46,' '=32;

  Integer t1000=integer(mod(time/1000,10));
  Integer t100=integer(mod(time/100,10));
  Integer t10=integer(mod(time/10,10));
  Integer t1=integer(mod(time,10));
  Integer td1=integer(mod(time*10,10));

  Integer f100=integer(mod(fan/100,10));
  Integer f10=integer(mod(fan/10,10));
  Integer f1=integer(mod(fan,10));

  Real lastRefreshTemp(start=-10.0, fixed=true);
  Real lastRefresh(start=-10.0, fixed=true);

  inner Modelica_DeviceDrivers.EmbeddedTargets.AVR.Blocks.Microcontroller mcu(desiredFrequency = 125, platform = Modelica_DeviceDrivers.EmbeddedTargets.AVR.Types.Platform.ATmega16)  annotation (
  Placement(visible = true, transformation(origin = {-62, 70}, extent = {{-22, -22}, {22, 22}}, rotation = 0)));
  Modelica_DeviceDrivers.EmbeddedTargets.AVR.Blocks.SynchronizeRealtime synchronizeRealtime1(timer = Modelica_DeviceDrivers.EmbeddedTargets.AVR.Types.TimerSelect.Timer0)  annotation (
  Placement(visible = true, transformation(origin = {-14, 70}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica_DeviceDrivers.EmbeddedTargets.AVR.Blocks.ADC adc(analogPort = Modelica_DeviceDrivers.EmbeddedTargets.AVR.Types.AnalogPort.A0, voltageReference = 5, voltageReferenceSelect = Modelica_DeviceDrivers.EmbeddedTargets.AVR.Types.VRefSelect.AREF)  annotation (
  Placement(visible = true,
  transformation(origin = {12, 18}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica_DeviceDrivers.EmbeddedTargets.AVR.Blocks.PWM pwm(prescaler = Modelica_DeviceDrivers.EmbeddedTargets.AVR.Types.TimerPrescaler.'1/1024',timer = Modelica_DeviceDrivers.EmbeddedTargets.AVR.Types.TimerSelect.Timer1, timerNumbers = {Modelica_DeviceDrivers.EmbeddedTargets.AVR.Types.TimerNumber.A, Modelica_DeviceDrivers.EmbeddedTargets.AVR.Types.TimerNumber.B})  annotation (
  Placement(visible = true, transformation(origin = {-42, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gain1(y(unit="degC"), u(unit="V"), k(unit="degC/V")=23.7252) "ADC raw*0.1163 on the SBHS factory firmware; AD590 with custom resistances, etc" annotation(Placement(visible = true, transformation(origin = {58, 18}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
equation
  connect(gain1.y, degC) annotation(Line(points={{69,18},{88,18},{88,0},{110,0},
          {110,0}},                                                                                  color = {0, 0, 127}));
  connect(adc.y, gain1.u) annotation(Line(points={{23,18},{46,18},{46,18},{46,18}},          color = {0, 0, 127}));
  connect(heat, pwm.u[1]) annotation(Line(points={{-120,-42},{-78,-42},{-78,0},{
          -56,0},{-56,-1},{-54,-1}},                                                                                  color = {255, 127, 0}));
  connect(fan, pwm.u[2]) annotation(Line(points={{-120,38},{-78,38},{-78,0},{-54,
          0},{-54,1}},                                                                                   color = {255, 127, 0}));
algorithm
  if time-lastRefreshTemp >= 0.5 then // We don't support sample(), or events... yet
    HD44780.updateTextBufferByte(lcd, 17, '0'+i10);
    HD44780.updateTextBufferByte(lcd, 18, '0'+i1);
    HD44780.updateTextBufferByte(lcd, 19, '.');
    HD44780.updateTextBufferByte(lcd, 20, '0'+d1);
    HD44780.updateTextBufferByte(lcd, 29, ' ');
    HD44780.updateTextBufferByte(lcd, 30, '0'+f100);
    HD44780.updateTextBufferByte(lcd, 31, '0'+f10);
    HD44780.updateTextBufferByte(lcd, 32, '0'+f1);
    lastRefreshTemp := time;
  end if;
  if time-lastRefresh >= 0.1 then // We don't support sample(), or events... yet
    HD44780.updateTextBufferByte(lcd, 21, ' ');
    HD44780.updateTextBufferByte(lcd, 22, '0'+t1000);
    HD44780.updateTextBufferByte(lcd, 23, '0'+t100);
    HD44780.updateTextBufferByte(lcd, 24, '0'+t10);
    HD44780.updateTextBufferByte(lcd, 25, '0'+t1);
    HD44780.updateTextBufferByte(lcd, 26, '.');
    HD44780.updateTextBufferByte(lcd, 27, '0'+td1);
    HD44780.updateTextBufferByte(lcd, 28, ' ');
    HD44780.updateDisplay(lcd);
    lastRefresh := time;
  end if;
annotation (
  defaultComponentName="sbhs",
  Icon(graphics={  Text(origin = {-120, -11}, extent = {{-24, 7}, {20, -7}}, textString = "Heat", fontSize = 25, fontName = "Arial"), Text(origin = {-120, 75}, extent = {{-18, 11}, {18, -11}}, textString = "Fan", fontSize = 25, fontName = "Arial"), Text(origin = {136, 22}, extent = {{-22, 14}, {22, -14}}, textString = "Temp [°C]", fontSize = 25, fontName = "Arial")}, coordinateSystem(initialScale = 0.1)), Diagram(graphics={  Text(origin = {-87, 17}, extent = {{-7, 7}, {7, -7}}, textString = "Timer1B", fontName = "Arial"), Text(origin = {-87, -21}, extent = {{-7, 7}, {7, -7}}, textString = "Timer1A", fontName = "Arial")}));
end Board;
