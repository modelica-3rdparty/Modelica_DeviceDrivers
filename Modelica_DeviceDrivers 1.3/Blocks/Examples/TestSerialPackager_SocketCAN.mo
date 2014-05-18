within Modelica_DeviceDrivers.Blocks.Examples;
model TestSerialPackager_SocketCAN
    extends Modelica.Icons.Example;

  import Modelica_DeviceDrivers;
  Modelica_DeviceDrivers.Blocks.Communication.SocketCAN.SocketCANConfig socketCANConfig1(ifr_name=
        "vcan0")
    annotation (Placement(transformation(extent={{-70,40},{-50,60}})));
  Modelica_DeviceDrivers.Blocks.Communication.SocketCAN.WriteMessage txMessage(
      can_id=2, config=socketCANConfig1) annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=180,
        origin={-22,-64})));
  Modelica_DeviceDrivers.Blocks.Packaging.SerialPackager.AddInteger addInteger(nu=1)
    annotation (Placement(transformation(extent={{-48,-22},{-28,-2}})));
  Modelica_DeviceDrivers.Blocks.Packaging.SerialPackager.PackUnsignedInteger packInt2(width=16, nu=1)
    annotation (Placement(transformation(extent={{-48,-48},{-28,-28}})));
  Modelica_DeviceDrivers.Blocks.Packaging.SerialPackager.PackUnsignedInteger
    packInt1(width=8, nu=1)
    annotation (Placement(transformation(extent={{-48,4},{-28,24}})));
  Modelica_DeviceDrivers.Blocks.Packaging.SerialPackager.Packager packager
    annotation (Placement(transformation(extent={{-48,30},{-28,50}})));
  Modelica.Blocks.Sources.IntegerExpression integerExpression1(y=integer(10*sin(
        time)))
    annotation (Placement(transformation(extent={{-88,-22},{-68,-2}})));
  Modelica.Blocks.Sources.IntegerExpression integerExpression2(y=integer(10*sin(
        time) + 10))
    annotation (Placement(transformation(extent={{-88,-48},{-68,-28}})));
  Modelica.Blocks.Sources.IntegerConstant integerConstant(k=3)
    annotation (Placement(transformation(extent={{-88,4},{-68,24}})));
  Modelica_DeviceDrivers.Blocks.Communication.SocketCAN.ReadMessage rxMessage(
      can_id=2, config=socketCANConfig2)
    annotation (Placement(transformation(extent={{20,30},{40,50}})));
  Modelica_DeviceDrivers.Blocks.Packaging.SerialPackager.UnpackUnsignedInteger
    unpackInt1(width=8, nu=1)
    annotation (Placement(transformation(extent={{20,4},{40,24}})));
  Modelica_DeviceDrivers.Blocks.Packaging.SerialPackager.GetInteger getInteger(
      nu=1) annotation (Placement(transformation(extent={{20,-22},{40,-2}})));
  Modelica_DeviceDrivers.Blocks.Communication.SocketCAN.SocketCANConfig socketCANConfig2(ifr_name=
        "vcan0")
    annotation (Placement(transformation(extent={{-6,40},{14,60}})));
  Modelica_DeviceDrivers.Blocks.Packaging.SerialPackager.UnpackUnsignedInteger
    unpackInt2(width=16)
    annotation (Placement(transformation(extent={{20,-52},{40,-32}})));
Modelica_DeviceDrivers.Blocks.OperatingSystem.SynchronizeRealtime
  synchronizeRealtime
  annotation (Placement(transformation(extent={{60,40},{80,60}})));
equation
  connect(integerExpression1.y,addInteger. u[1]) annotation (Line(
      points={{-67,-12},{-50,-12}},
      color={255,127,0}));
  connect(integerExpression2.y, packInt2.u)
                                           annotation (Line(
      points={{-67,-38},{-50,-38}},
      color={255,127,0}));
  connect(integerConstant.y,packInt1. u) annotation (Line(
      points={{-67,14},{-50,14}},
      color={255,127,0}));
  connect(packager.pkgOut,packInt1. pkgIn) annotation (Line(
      points={{-38,29.2},{-38,24.8}},
      pattern=LinePattern.None));
  connect(packInt1.pkgOut[1],addInteger. pkgIn) annotation (Line(
      points={{-38,3.2},{-38,-1.2}},
      pattern=LinePattern.None));
  connect(addInteger.pkgOut[1], packInt2.pkgIn)
                                               annotation (Line(
      points={{-38,-22.8},{-38,-27.2}},
      pattern=LinePattern.None));
  connect(unpackInt1.pkgOut[1], getInteger.pkgIn) annotation (Line(
      points={{30,3.2},{30,-1.2}},
      pattern=LinePattern.None));
  connect(getInteger.pkgOut[1], unpackInt2.pkgIn) annotation (Line(
      points={{30,-22.8},{30,-31.2}},
      pattern=LinePattern.None));
  connect(packInt2.pkgOut[1], txMessage.pkgIn) annotation (Line(
      points={{-38,-48.8},{-38,-64},{-32.8,-64}},
      pattern=LinePattern.None));
  connect(rxMessage.pkgOut, unpackInt1.pkgIn) annotation (Line(
      points={{40.8,40},{44,40},{44,28},{30,28},{30,24.8}},
      pattern=LinePattern.None));
annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}),
                    graphics={Text(
          extent={{-94,92},{96,64}},
          lineColor={0,0,255},
          textString="Please see documentation for system requirements
for using the Linux Socket CAN bus interface!")}),
                               experiment(StopTime=1.0), Documentation(info="<html>
<h4><font color=\"#008000\">Example for Linux Socket CAN interface support</font></h4>
<p><b>Will only work on Linux!</b></p>
<p>Please, read the package information for <code><a href=\"modelica://Modelica_DeviceDrivers.Blocks.Communication.SocketCAN\">SocketCAN</a></code> first!</p>

<h4><font color=\"#008000\">The example</font></h4>
<p>The example is configured to use the virtual CAN interface &quot;<code>vcan0</code>&quot;. The
<code><a href=\"modelica://Modelica_DeviceDrivers.Blocks.Communication.SocketCAN\">SocketCAN</a></code> package documentation describes
briefly how to bring up such a virtual CAN interface in Linux.</p>

<p>Two sockets are opened in the example: One for sending messages, the other for receiving them.
The <code>SerialPackager</code> blocks are used to add/retrieve data to/from the messages. </p>
</html>"));
end TestSerialPackager_SocketCAN;
