within Modelica_DeviceDrivers.Blocks.Examples;
model TestSerialPackager_SoftingCAN
    extends Modelica.Icons.Example;

  import Modelica_DeviceDrivers;
Modelica_DeviceDrivers.Blocks.Communication.SoftingCAN.SoftingCANConfig
                                                        softingCANConfig(nu=2)
  annotation (Placement(transformation(extent={{-64,32},{-44,52}})));
Modelica_DeviceDrivers.Blocks.Communication.SoftingCAN.SoftingReadMessage
  rxMessage(ident=101)
  annotation (Placement(transformation(extent={{12,20},{32,40}})));
Modelica_DeviceDrivers.Blocks.OperatingSystem.SynchronizeRealtime
  synchronizeRealtime
  annotation (Placement(transformation(extent={{40,32},{60,52}})));
Modelica_DeviceDrivers.Blocks.Packaging.SerialPackager.UnpackUnsignedInteger
                                                                   unpackInt(
    width=8, nu=1)
  annotation (Placement(transformation(extent={{12,-6},{32,14}})));
Modelica_DeviceDrivers.Blocks.Packaging.SerialPackager.UnpackUnsignedInteger
                                                                   unpackInt1(
   width=8, bitOffset=0,
  nu=1)
  annotation (Placement(transformation(extent={{12,-32},{32,-12}})));
Modelica_DeviceDrivers.Blocks.Packaging.SerialPackager.UnpackUnsignedInteger
                                                                   unpackInt2(
   width=8, bitOffset=0,
  nu=1)
  annotation (Placement(transformation(extent={{12,-58},{32,-38}})));
Modelica_DeviceDrivers.Blocks.Packaging.SerialPackager.UnpackUnsignedInteger
                                                                   unpackInt3(
   width=8, bitOffset=0,
  nu=1)
  annotation (Placement(transformation(extent={{12,-84},{32,-64}})));
Modelica_DeviceDrivers.Blocks.Packaging.SerialPackager.UnpackUnsignedInteger
                                                                   unpackInt4(
   width=8, bitOffset=0,
  nu=1)
  annotation (Placement(transformation(extent={{44,-6},{64,14}})));
Modelica_DeviceDrivers.Blocks.Packaging.SerialPackager.UnpackUnsignedInteger
                                                                   unpackInt5(
   width=8, bitOffset=0,
  nu=1)
  annotation (Placement(transformation(extent={{44,-32},{64,-12}})));
Modelica_DeviceDrivers.Blocks.Packaging.SerialPackager.UnpackUnsignedInteger
                                                                   unpackInt6(
   width=8, bitOffset=0,
  nu=1)
  annotation (Placement(transformation(extent={{44,-58},{64,-38}})));
Modelica_DeviceDrivers.Blocks.Packaging.SerialPackager.UnpackUnsignedInteger
                                                                   unpackInt7(
   width=8, bitOffset=0)
  annotation (Placement(transformation(extent={{44,-84},{64,-64}})));
  Modelica_DeviceDrivers.Blocks.Packaging.SerialPackager.AddInteger addInteger(nu=1)
    annotation (Placement(transformation(extent={{-34,-32},{-14,-12}})));
  Modelica_DeviceDrivers.Blocks.Packaging.SerialPackager.PackUnsignedInteger
    packInt(width=16, nu=1)
    annotation (Placement(transformation(extent={{-34,-58},{-14,-38}})));
  Modelica_DeviceDrivers.Blocks.Packaging.SerialPackager.PackUnsignedInteger
    packInt1(width=8, nu=1)
    annotation (Placement(transformation(extent={{-34,-6},{-14,14}})));
  Modelica_DeviceDrivers.Blocks.Communication.SoftingCAN.SoftingWriteMessage
                                                             txMessage(ident=
        100) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={-24,-74})));
  Modelica_DeviceDrivers.Blocks.Packaging.SerialPackager.Packager packager
    annotation (Placement(transformation(extent={{-34,20},{-14,40}})));
  Modelica.Blocks.Sources.IntegerExpression integerExpression1(y=integer(10*sin(
        time)))
    annotation (Placement(transformation(extent={{-74,-32},{-54,-12}})));
  Modelica.Blocks.Sources.IntegerExpression integerExpression2(y=integer(10*sin(
        time) + 10))
    annotation (Placement(transformation(extent={{-74,-58},{-54,-38}})));
  Modelica.Blocks.Sources.IntegerConstant integerConstant(k=3)
    annotation (Placement(transformation(extent={{-74,-6},{-54,14}})));
equation
connect(unpackInt2.pkgOut[1], unpackInt3.pkgIn) annotation (Line(
    points={{22,-58.8},{22,-63.2}},
    pattern=LinePattern.None));
connect(unpackInt3.pkgOut[1], unpackInt4.pkgIn) annotation (Line(
    points={{22,-84.8},{22,-90},{38,-90},{38,18},{54,18},{54,14.8}},
    pattern=LinePattern.None));
connect(unpackInt4.pkgOut[1], unpackInt5.pkgIn) annotation (Line(
    points={{54,-6.8},{54,-11.2}},
    pattern=LinePattern.None));
connect(unpackInt5.pkgOut[1], unpackInt6.pkgIn) annotation (Line(
    points={{54,-32.8},{54,-37.2}},
    pattern=LinePattern.None));
connect(unpackInt6.pkgOut[1], unpackInt7.pkgIn) annotation (Line(
    points={{54,-58.8},{54,-63.2}},
    pattern=LinePattern.None));
connect(unpackInt.pkgOut[1], unpackInt1.pkgIn) annotation (Line(
    points={{22,-6.8},{22,-11.2}},
    pattern=LinePattern.None));
connect(unpackInt1.pkgOut[1], unpackInt2.pkgIn) annotation (Line(
    points={{22,-32.8},{22,-37.2}},
    pattern=LinePattern.None));
connect(rxMessage.pkgOut, unpackInt.pkgIn) annotation (Line(
    points={{22,19.2},{22,14.8}},
    pattern=LinePattern.None));
  connect(integerExpression1.y,addInteger. u[1]) annotation (Line(
      points={{-53,-22},{-36,-22}},
      color={255,127,0}));
  connect(integerExpression2.y,packInt. u) annotation (Line(
      points={{-53,-48},{-36,-48}},
      color={255,127,0}));
  connect(integerConstant.y,packInt1. u) annotation (Line(
      points={{-53,4},{-36,4}},
      color={255,127,0}));
  connect(packager.pkgOut,packInt1. pkgIn) annotation (Line(
      points={{-24,19.2},{-24,14.8}},
      pattern=LinePattern.None));
  connect(packInt1.pkgOut[1],addInteger. pkgIn) annotation (Line(
      points={{-24,-6.8},{-24,-11.2}},
      pattern=LinePattern.None));
  connect(addInteger.pkgOut[1],packInt. pkgIn) annotation (Line(
      points={{-24,-32.8},{-24,-37.2}},
      pattern=LinePattern.None));
  connect(packInt.pkgOut[1],txMessage. pkgIn) annotation (Line(
      points={{-24,-58.8},{-24,-63.2}},
      pattern=LinePattern.None));
  connect(txMessage.softingCANBus, softingCANConfig.softingCANBus[1])
    annotation (Line(
      points={{-24,-84.8},{-24,-88},{-6,-88},{-6,41},{-43.2,41}},
      pattern=LinePattern.None));
  connect(rxMessage.softingCANBus, softingCANConfig.softingCANBus[2])
    annotation (Line(
      points={{22,40.8},{22,43},{-43.2,43}},
      pattern=LinePattern.None));
annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}),
                    graphics={Text(
          extent={{-94,92},{96,64}},
          lineColor={0,0,255},
          textString="Please see documentation for system requirements
for using the Softing CAN bus interface!")}),
                               experiment(StopTime=1.0), Documentation(info="<html>
<h4><font color=\"#008000\">Support for Softing CAN bus</font></h4>
<p><b>Please, read the package information for <a href=\"modelica://Modelica_DeviceDrivers.Blocks.Communication.SoftingCAN\"><code>SoftingCAN</code></a> first!</b></p>
<h4><font color=\"#008000\">The example</font></h4>
<p>
The example is configured for the \"CANusb\" interface card from Softing (<a href=\"http://www.softing.com/\">www.softing.com</a>) (but, given that the <code>deviceName</code> parameter is set correctly, should work with all of their interface cards supporting their Softing CAN Layer 2 software API). Two messages are defined: <code>txMessage</code> for sending and <code>rxMessage</code> for receiving. The <code>SerialPackager</code> blocks are used to add/retrieve data to/from the messages.
</p>
</html>"));
end TestSerialPackager_SoftingCAN;
