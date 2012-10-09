within Modelica_DeviceDrivers.Incubate;
model TestSerialPackager_CAN_Read
    extends Modelica.Icons.Example;

  import Modelica_DeviceDrivers;
Modelica_DeviceDrivers.Incubate.Blocks.SoftingCANConfig softingCANConfig(nu=2)
  annotation (Placement(transformation(extent={{-80,80},{-60,100}})));
Modelica_DeviceDrivers.Incubate.Blocks.SoftingReadMessage
  rxMessage(ident=0)
  annotation (Placement(transformation(extent={{-38,62},{-18,82}})));
Modelica_DeviceDrivers.Blocks.OperatingSystem.SynchronizeRealtime
  synchronizeRealtime
  annotation (Placement(transformation(extent={{70,70},{90,90}})));
Modelica_DeviceDrivers.Blocks.Packaging.SerialPackager.UnpackUnsignedInteger
                                                                   unpackInt(
    width=8, nu=1)
  annotation (Placement(transformation(extent={{-38,34},{-18,54}})));
Modelica_DeviceDrivers.Blocks.Packaging.SerialPackager.UnpackUnsignedInteger
                                                                   unpackInt1(
   width=8, bitOffset=0,
  nu=1)
  annotation (Placement(transformation(extent={{-38,2},{-18,22}})));
Modelica_DeviceDrivers.Blocks.Packaging.SerialPackager.UnpackUnsignedInteger
                                                                   unpackInt2(
   width=8, bitOffset=0,
  nu=1)
  annotation (Placement(transformation(extent={{-38,-28},{-18,-8}})));
Modelica_DeviceDrivers.Blocks.Packaging.SerialPackager.UnpackUnsignedInteger
                                                                   unpackInt3(
   width=8, bitOffset=0,
  nu=1)
  annotation (Placement(transformation(extent={{-38,-58},{-18,-38}})));
Modelica_DeviceDrivers.Blocks.Packaging.SerialPackager.UnpackUnsignedInteger
                                                                   unpackInt4(
   width=8, bitOffset=0,
  nu=1)
  annotation (Placement(transformation(extent={{2,32},{22,52}})));
Modelica_DeviceDrivers.Blocks.Packaging.SerialPackager.UnpackUnsignedInteger
                                                                   unpackInt5(
   width=8, bitOffset=0,
  nu=1)
  annotation (Placement(transformation(extent={{2,2},{22,22}})));
Modelica_DeviceDrivers.Blocks.Packaging.SerialPackager.UnpackUnsignedInteger
                                                                   unpackInt6(
   width=8, bitOffset=0,
  nu=1)
  annotation (Placement(transformation(extent={{2,-28},{22,-8}})));
Modelica_DeviceDrivers.Blocks.Packaging.SerialPackager.UnpackUnsignedInteger
                                                                   unpackInt7(
   width=8, bitOffset=0)
  annotation (Placement(transformation(extent={{2,-60},{22,-40}})));
Modelica_DeviceDrivers.Incubate.Blocks.SoftingReadMessage
  rxMessage1(ident=1)
  annotation (Placement(transformation(extent={{34,62},{54,82}})));
Modelica_DeviceDrivers.Blocks.Packaging.SerialPackager.UnpackUnsignedInteger
                                                                   unpackInt8(
    width=8, nu=1)
  annotation (Placement(transformation(extent={{34,32},{54,52}})));
Modelica_DeviceDrivers.Blocks.Packaging.SerialPackager.UnpackUnsignedInteger
                                                                   unpackInt9(
   width=8, bitOffset=0,
  nu=1)
  annotation (Placement(transformation(extent={{34,2},{54,22}})));
Modelica_DeviceDrivers.Blocks.Packaging.SerialPackager.UnpackUnsignedInteger
                                                                   unpackInt10(
   width=8, bitOffset=0,
  nu=1)
  annotation (Placement(transformation(extent={{34,-28},{54,-8}})));
Modelica_DeviceDrivers.Blocks.Packaging.SerialPackager.UnpackUnsignedInteger
                                                                   unpackInt11(
   width=8, bitOffset=0,
  nu=1)
  annotation (Placement(transformation(extent={{34,-60},{54,-40}})));
Modelica_DeviceDrivers.Blocks.Packaging.SerialPackager.UnpackUnsignedInteger
                                                                   unpackInt12(
   width=8, bitOffset=0,
  nu=1)
  annotation (Placement(transformation(extent={{74,32},{94,52}})));
Modelica_DeviceDrivers.Blocks.Packaging.SerialPackager.UnpackUnsignedInteger
                                                                   unpackInt13(
   width=8, bitOffset=0,
  nu=1)
  annotation (Placement(transformation(extent={{74,2},{94,22}})));
Modelica_DeviceDrivers.Blocks.Packaging.SerialPackager.UnpackUnsignedInteger
                                                                   unpackInt14(
   width=8, bitOffset=0,
  nu=1)
  annotation (Placement(transformation(extent={{74,-30},{94,-10}})));
Modelica_DeviceDrivers.Blocks.Packaging.SerialPackager.UnpackUnsignedInteger
                                                                   unpackInt15(
   width=8, bitOffset=0)
  annotation (Placement(transformation(extent={{74,-60},{94,-40}})));
equation
connect(softingCANConfig.softingCANBus[1], rxMessage1.softingCANBus)
  annotation (Line(
    points={{-59.2,89},{44,89},{44,82.8}},
    color={0,0,0},
    pattern=LinePattern.None,
    smooth=Smooth.None));
connect(rxMessage.softingCANBus, softingCANConfig.softingCANBus[2])
  annotation (Line(
    points={{-28,82.8},{-28,91},{-59.2,91}},
    color={0,0,0},
    pattern=LinePattern.None,
    smooth=Smooth.None));
connect(unpackInt2.pkgOut[1], unpackInt3.pkgIn) annotation (Line(
    points={{-28,-28.8},{-28,-37.2}},
    color={0,0,0},
    pattern=LinePattern.None,
    smooth=Smooth.None));
connect(unpackInt3.pkgOut[1], unpackInt4.pkgIn) annotation (Line(
    points={{-28,-58.8},{-28,-66},{-12,-66},{-12,64},{12,64},{12,52.8}},
    color={0,0,0},
    pattern=LinePattern.None,
    smooth=Smooth.None));
connect(unpackInt4.pkgOut[1], unpackInt5.pkgIn) annotation (Line(
    points={{12,31.2},{12,22.8}},
    color={0,0,0},
    pattern=LinePattern.None,
    smooth=Smooth.None));
connect(unpackInt5.pkgOut[1], unpackInt6.pkgIn) annotation (Line(
    points={{12,1.2},{12,-7.2}},
    color={0,0,0},
    pattern=LinePattern.None,
    smooth=Smooth.None));
connect(unpackInt6.pkgOut[1], unpackInt7.pkgIn) annotation (Line(
    points={{12,-28.8},{12,-39.2}},
    color={0,0,0},
    pattern=LinePattern.None,
    smooth=Smooth.None));
connect(unpackInt8.pkgOut[1], unpackInt9.pkgIn) annotation (Line(
    points={{44,31.2},{44,22.8}},
    color={0,0,0},
    pattern=LinePattern.None,
    smooth=Smooth.None));
connect(unpackInt9.pkgOut[1], unpackInt10.pkgIn) annotation (Line(
    points={{44,1.2},{44,-7.2}},
    color={0,0,0},
    pattern=LinePattern.None,
    smooth=Smooth.None));
connect(unpackInt10.pkgOut[1], unpackInt11.pkgIn) annotation (Line(
    points={{44,-28.8},{44,-39.2}},
    color={0,0,0},
    pattern=LinePattern.None,
    smooth=Smooth.None));
connect(unpackInt11.pkgOut[1], unpackInt12.pkgIn) annotation (Line(
    points={{44,-60.8},{44,-66},{62,-66},{62,60},{84,60},{84,52.8}},
    color={0,0,0},
    pattern=LinePattern.None,
    smooth=Smooth.None));
connect(unpackInt12.pkgOut[1], unpackInt13.pkgIn) annotation (Line(
    points={{84,31.2},{84,22.8}},
    color={0,0,0},
    pattern=LinePattern.None,
    smooth=Smooth.None));
connect(unpackInt13.pkgOut[1], unpackInt14.pkgIn) annotation (Line(
    points={{84,1.2},{84,-9.2},{84,-9.2}},
    color={0,0,0},
    pattern=LinePattern.None,
    smooth=Smooth.None));
connect(unpackInt14.pkgOut[1], unpackInt15.pkgIn) annotation (Line(
    points={{84,-30.8},{84,-39.2}},
    color={0,0,0},
    pattern=LinePattern.None,
    smooth=Smooth.None));
connect(unpackInt.pkgOut[1], unpackInt1.pkgIn) annotation (Line(
    points={{-28,33.2},{-28,22.8},{-28,22.8}},
    color={0,0,0},
    pattern=LinePattern.None,
    smooth=Smooth.None));
connect(unpackInt1.pkgOut[1], unpackInt2.pkgIn) annotation (Line(
    points={{-28,1.2},{-28,-7.2}},
    color={0,0,0},
    pattern=LinePattern.None,
    smooth=Smooth.None));
connect(rxMessage.pkgOut, unpackInt.pkgIn) annotation (Line(
    points={{-28,61.2},{-28,54.8}},
    color={0,0,0},
    pattern=LinePattern.None,
    smooth=Smooth.None));
connect(rxMessage1.pkgOut, unpackInt8.pkgIn) annotation (Line(
    points={{44,61.2},{44,52.8}},
    color={0,0,0},
    pattern=LinePattern.None,
    smooth=Smooth.None));
annotation (Diagram(graphics));
end TestSerialPackager_CAN_Read;
