within Modelica_DeviceDrivers.Blocks.Examples;
model TestHardwareIOComedi
  "Example for comedi daq support using USB-DUX D (http://www.linux-usb-daq.co.uk/)"
  import Modelica_DeviceDrivers;
extends Modelica.Icons.Example;
  Modelica_DeviceDrivers.Blocks.HardwareIO.Comedi.DataWrite
                             dataWrite(comedi=comedi.dh, subDevice=1)
    annotation (Placement(transformation(extent={{-40,20},{-20,40}})));

  Modelica_DeviceDrivers.Blocks.HardwareIO.Comedi.ComediConfig
                                                        comedi
    annotation (Placement(transformation(extent={{-80,60},{-60,80}})));
  Modelica.Blocks.Sources.Sine sine(
    f=2,
    amplitude=2000,
    offset=2000)
    annotation (Placement(transformation(extent={{-100,20},{-80,40}})));
  Modelica.Blocks.Math.RealToInteger realToInteger
    annotation (Placement(transformation(extent={{-72,20},{-52,40}})));
  Modelica_DeviceDrivers.Blocks.HardwareIO.Comedi.DataRead dataRead(
    comedi=comedi.dh,
    subDevice=0,
    channel=0) annotation (Placement(transformation(extent={{0,20},{20,40}})));
  Modelica_DeviceDrivers.Blocks.OperatingSystem.RealtimeSynchronize
    realtimeSynchronize
    annotation (Placement(transformation(extent={{60,60},{80,80}})));
  Modelica_DeviceDrivers.Blocks.HardwareIO.Comedi.DIOWrite dioWrite(
                                                                   comedi=
        comedi.dh)
    annotation (Placement(transformation(extent={{-40,-20},{-20,0}})));
  Modelica_DeviceDrivers.Blocks.HardwareIO.Comedi.DIORead dioRead(
                                                                 channel=1,
      comedi=comedi.dh)
    annotation (Placement(transformation(extent={{0,-20},{20,0}})));
  Modelica.Blocks.Logical.Less less
    annotation (Placement(transformation(extent={{-70,-20},{-50,0}})));
  Modelica.Blocks.Sources.Constant const(k=2000)
    annotation (Placement(transformation(extent={{-100,-60},{-80,-40}})));
  Modelica_DeviceDrivers.Blocks.HardwareIO.Comedi.PhysicalDataWrite dataWrite1(
      comedi=comedi.dh, channel=1)
    annotation (Placement(transformation(extent={{-60,-80},{-40,-60}})));
  Modelica.Blocks.Sources.Sine sine1(
    f=2,
    amplitude=4,
    offset=0)
    annotation (Placement(transformation(extent={{-100,-100},{-80,-80}})));
  Modelica_DeviceDrivers.Blocks.HardwareIO.Comedi.PhysicalDataRead dataRead1(
      comedi=comedi.dh, channel=1)
    annotation (Placement(transformation(extent={{-20,-80},{0,-60}})));
equation
  connect(sine.y, realToInteger.u) annotation (Line(
      points={{-79,30},{-74,30}},
      color={0,0,127}));
  connect(realToInteger.y, dataWrite.u) annotation (Line(
      points={{-51,30},{-42,30}},
      color={255,127,0}));
  connect(const.y, less.u2) annotation (Line(
      points={{-79,-50},{-76,-50},{-76,-18},{-72,-18}},
      color={0,0,127}));
  connect(less.u1, sine.y) annotation (Line(
      points={{-72,-10},{-78,-10},{-78,30},{-79,30}},
      color={0,0,127}));
  connect(less.y, dioWrite.u) annotation (Line(
      points={{-49,-10},{-42,-10}},
      color={255,0,255}));
  connect(sine1.y, dataWrite1.u) annotation (Line(
      points={{-79,-90},{-72,-90},{-72,-70},{-62,-70}},
      color={0,0,127}));
  annotation (Diagram(graphics={Text(
          extent={{-108,106},{108,76}},
          textColor={0,0,255},
          textString="Example for USB-DUX D
Assuming input channels are electrical connected to corresponding output channels we should read what we wrote")}),
      experiment(StopTime=5.0),
    Documentation(info="<html>
<p>
<b>Important: Works only under Linux.</b> The reason for this is, that the interfaced <a href=\"http://www.comedi.org/\">Comedi</a> device drivers are only available for Linux.
</p>
<p>
Example tested with <a href=\"http://www.linux-usb-daq.co.uk/tech2_usbdux/\">USB-DUX D</a>. Assuming input channels are electrical connected to corresponding output channels we should read what we wrote
</p>
</html>"));
end TestHardwareIOComedi;
