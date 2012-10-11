within Modelica_DeviceDrivers.Incubate;
model TestSerialPackager_SoftingCAN_Write
    extends Modelica.Icons.Example;
  import Modelica_DeviceDrivers;
  Modelica_DeviceDrivers.Blocks.Communication.SoftingCAN.SoftingCANConfig
                                                          softingCANConfig(nu=1)
    annotation (Placement(transformation(extent={{-72,-80},{-52,-60}})));
  Modelica_DeviceDrivers.Blocks.OperatingSystem.SynchronizeRealtime
    synchronizeRealtime
    annotation (Placement(transformation(extent={{70,70},{90,90}})));
  Modelica_DeviceDrivers.Blocks.Packaging.SerialPackager.AddInteger addInteger(nu=1)
    annotation (Placement(transformation(extent={{-40,14},{-20,34}})));
  Modelica_DeviceDrivers.Blocks.Packaging.SerialPackager.PackUnsignedInteger
    packInt(width=16, nu=1)
    annotation (Placement(transformation(extent={{-40,-26},{-20,-6}})));
  Modelica_DeviceDrivers.Blocks.Packaging.SerialPackager.PackUnsignedInteger
    packInt1(width=8, nu=1)
    annotation (Placement(transformation(extent={{-40,48},{-20,68}})));
  Modelica_DeviceDrivers.Blocks.Communication.SoftingCAN.SoftingWriteMessage
                                                             txMessage(ident=
        100) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={-30,-50})));
  Modelica_DeviceDrivers.Blocks.Packaging.SerialPackager.Packager packager
    annotation (Placement(transformation(extent={{-40,80},{-20,100}})));
  Modelica.Blocks.Sources.IntegerExpression integerExpression1(y=integer(10*sin(
        time)))
    annotation (Placement(transformation(extent={{-80,14},{-60,34}})));
  Modelica.Blocks.Sources.IntegerExpression integerExpression2(y=integer(10*sin(
        time) + 10))
    annotation (Placement(transformation(extent={{-80,-26},{-60,-6}})));
  Modelica.Blocks.Sources.IntegerConstant integerConstant(k=3)
    annotation (Placement(transformation(extent={{-80,48},{-60,68}})));
equation
  connect(integerExpression1.y, addInteger.u[1]) annotation (Line(
      points={{-59,24},{-42,24}},
      color={255,127,0},
      smooth=Smooth.None));
  connect(integerExpression2.y, packInt.u) annotation (Line(
      points={{-59,-16},{-42,-16}},
      color={255,127,0},
      smooth=Smooth.None));
  connect(integerConstant.y, packInt1.u) annotation (Line(
      points={{-59,58},{-42,58}},
      color={255,127,0},
      smooth=Smooth.None));
  connect(txMessage.softingCANBus, softingCANConfig.softingCANBus[1])
    annotation (Line(
      points={{-30,-60.8},{-30,-70},{-51.2,-70}},
      color={0,0,0},
      pattern=LinePattern.None,
      smooth=Smooth.None));
  connect(packager.pkgOut, packInt1.pkgIn) annotation (Line(
      points={{-30,79.2},{-30,68.8}},
      color={0,0,0},
      pattern=LinePattern.None,
      smooth=Smooth.None));
  connect(packInt1.pkgOut[1], addInteger.pkgIn) annotation (Line(
      points={{-30,47.2},{-30,34.8}},
      color={0,0,0},
      pattern=LinePattern.None,
      smooth=Smooth.None));
  connect(addInteger.pkgOut[1], packInt.pkgIn) annotation (Line(
      points={{-30,13.2},{-30,-5.2}},
      color={0,0,0},
      pattern=LinePattern.None,
      smooth=Smooth.None));
  connect(packInt.pkgOut[1], txMessage.pkgIn) annotation (Line(
      points={{-30,-26.8},{-30,-39.2}},
      color={0,0,0},
      pattern=LinePattern.None,
      smooth=Smooth.None));
  annotation (Diagram(graphics));
end TestSerialPackager_SoftingCAN_Write;
