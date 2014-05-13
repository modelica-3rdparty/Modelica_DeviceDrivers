within Modelica_DeviceDrivers.Blocks.Examples;
model TestSerialPackager_SerialPort
  "Test case to send two integer values using serial interface"
extends Modelica.Icons.Example;
  Modelica_DeviceDrivers.Blocks.Communication.SerialPortSend serialSend(
    autoBufferSize=true,
    baud=Modelica_DeviceDrivers.Utilities.Types.SerialBaudRate.B57600,
    Serial_Port="/dev/pts/1",
    sampleTime=0.1)           annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-46,-90})));
  Modelica_DeviceDrivers.Blocks.Packaging.SerialPackager.Packager packager
    annotation (Placement(transformation(extent={{-58,42},{-38,62}})));
  Modelica_DeviceDrivers.Blocks.Communication.SerialPortReceive serialReceive(
      baud=Modelica_DeviceDrivers.Utilities.Types.SerialBaudRate.B57600,
      Serial_Port="/dev/pts/3",
    sampleTime=0.1)
    annotation (Placement(transformation(extent={{-30,40},{-10,60}})));
  Modelica_DeviceDrivers.Blocks.OperatingSystem.SynchronizeRealtime synchronizeRealtime
    annotation (Placement(transformation(extent={{62,50},{82,70}})));
  Packaging.SerialPackager.UnpackUnsignedInteger unpackInt(      width=10, nu=1)
    annotation (Placement(transformation(extent={{-18,-2},{2,18}})));
  Packaging.SerialPackager.GetString getString(nu=1)
    annotation (Placement(transformation(extent={{-18,-34},{2,-14}})));
  Modelica.Blocks.Sources.IntegerExpression findString(y=
        Modelica.Utilities.Strings.find(getString.data, "examp"))
    annotation (Placement(transformation(extent={{10,-36},{84,-12}})));
  Modelica.Blocks.Sources.IntegerExpression integerExpression(y=integer(3*sin(
        time) + 3))
    annotation (Placement(transformation(extent={{-100,0},{-74,20}})));
  Packaging.SerialPackager.PackUnsignedInteger packInt(      width=10, nu=1)
    annotation (Placement(transformation(extent={{-56,0},{-36,20}})));
  Packaging.SerialPackager.AddString addString(      data=stringEx.y, nu=1)
    annotation (Placement(transformation(extent={{-56,-30},{-36,-10}})));
  Utilities.StringExpression stringEx(y="An example String\n")
    annotation (Placement(transformation(extent={{-94,-28},{-66,-10}})));
  Packaging.SerialPackager.AddInteger addInteger(nu=1)
    annotation (Placement(transformation(extent={{-56,-66},{-36,-46}})));
  Modelica.Blocks.Sources.IntegerExpression integerExpression1(
                                                              y=integer(3*sin(
        time) + 3))
    annotation (Placement(transformation(extent={{-100,-66},{-72,-46}})));
  Packaging.SerialPackager.GetInteger getInteger
    annotation (Placement(transformation(extent={{-18,-66},{2,-46}})));
equation
  connect(unpackInt.pkgOut[1],getString. pkgIn) annotation (Line(
      points={{-8,-2.8},{-8,-13.2}},
      pattern=LinePattern.None));
  connect(integerExpression.y,packInt. u) annotation (Line(
      points={{-72.7,10},{-58,10}},
      color={255,127,0}));
  connect(packInt.pkgOut[1],addString. pkgIn) annotation (Line(
      points={{-46,-0.8},{-46,-9.2}},
      pattern=LinePattern.None));
  connect(serialReceive.pkgOut, unpackInt.pkgIn) annotation (Line(
      points={{-9.2,50},{-8,50},{-8,18.8}},
      pattern=LinePattern.None));
  connect(packager.pkgOut, packInt.pkgIn) annotation (Line(
      points={{-48,41.2},{-48,31.6},{-46,31.6},{-46,20.8}},
      pattern=LinePattern.None));
  connect(addString.pkgOut[1], addInteger.pkgIn) annotation (Line(
      points={{-46,-30.8},{-46,-45.2}},
      pattern=LinePattern.None));
  connect(addInteger.pkgOut[1], serialSend.pkgIn) annotation (Line(
      points={{-46,-66.8},{-46,-79.2}},
      pattern=LinePattern.None));
  connect(integerExpression1.y, addInteger.u[1]) annotation (Line(
      points={{-70.6,-56},{-58,-56}},
      color={255,127,0}));
  connect(getString.pkgOut[1], getInteger.pkgIn) annotation (Line(
      points={{-8,-34.8},{-8,-45.2}},
      pattern=LinePattern.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics={Text(
          extent={{-104,96},{96,76}},
          lineColor={0,0,255},
          textString="Currently only supported for Linux.
Please read the model documentation first.")}),
                                   Documentation(info="<html>
<h4><span style=\"color:#008000\">Example for serial port support</span></h4>
<h4>Currently only supported for Linux!</h4>
<h4><span style=\"color:#008000\">Hardware setup</span></h4>
<p>In order to execute the example an appropriate phyiscal connection between the sending and the receiving serial port needs to be established, (e.g., by using a null modem cable between the two serial port interfaces <a href=\"http://en.wikipedia.org/wiki/Null_modem\">http://en.wikipedia.org/wiki/Null_modem</a>). In fact a minimal mull modem with lines (<code>TxD</code>, <code>Rxd</code> and <code>GND</code>) is sufficient. Next,t he <code>SerialPortReceive</code> and <code>SerialPortSend</code> blocks parameters must be updated with the device filenames corresponding to the connected physical serial ports. Now, the example can be executed. </p>
<h4><span style=\"color:#008000\">Alternative: Using virtual serial port devices for test purposes</span></h4>
<p>The run the example without serial port hardware, it is possible to resort to virtual serial ports. One possible way of doing this is described in the following. </p>
<p>Make sure that <i>socat</i> is installed, e.g., on an Ubuntu machine do </p>
<pre>sudo aptitude install socat</pre>
<p>Now open a console and create two virtual serial port interfaces using socat: </p>
<pre>socat -d -d pty,raw,echo=0 pty,raw,echo=0</pre>
<p>The socat program will print the device file names that it created. The output will resemble the following:</p>
<pre>2013/11/24 15:20:21 socat[3262] N PTY is /dev/pts/1
2013/11/24 15:20:21 socat[3262] N PTY is /dev/pts/3
2013/11/24 15:20:21 socat[3262] N starting data transfer loop with FDs [3,3] and [5,5]</pre>
<p>Use them in the Send and Receive block. E.g., for the output above you would use <code>&QUOT;/dev/pts/1&QUOT;</code> in <code>SerialPortReceive</code> and <code>&QUOT;/dev/pts/3&QUOT;</code> in <code>SerialPortSend</code>. </p>
<p>You may have also have a look at the discussion about virtual serial port devices on stackoverflow<a href=\"http://stackoverflow.com/questions/52187/virtual-serial-port-for-linux\">http://stackoverflow.com/questions/52187/virtual-serial-port-for-linux</a>.</p>
</html>"));
end TestSerialPackager_SerialPort;
