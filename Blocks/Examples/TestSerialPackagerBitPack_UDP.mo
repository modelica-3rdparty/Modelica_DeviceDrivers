within Modelica_DeviceDrivers.Blocks.Examples;
model TestSerialPackagerBitPack_UDP
extends Modelica.Icons.Example;
  Modelica_DeviceDrivers.Blocks.Communication.UDPSend
                                  uDPSend(port_send=10002)
                                                 annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={-30,-88})));
  Modelica.Blocks.Sources.IntegerExpression integerExpression(y=integer(5*sin(
        time) + 10))
    annotation (Placement(transformation(extent={{-78,-2},{-58,18}})));
  Modelica_DeviceDrivers.Blocks.Packaging.SerialPackager.Packager
                          packager
    annotation (Placement(transformation(extent={{-40,62},{-20,82}})));
  Modelica_DeviceDrivers.Blocks.Packaging.SerialPackager.PackUnsignedInteger
                                                                   packInt(
      width=10, bitOffset=0,
    nu=1)
    annotation (Placement(transformation(extent={{-40,-2},{-20,18}})));
  Modelica_DeviceDrivers.Blocks.Communication.UDPReceive
                            uDPReceive2_1(port_recv=10002) annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={30,68})));
  Modelica_DeviceDrivers.Blocks.Packaging.SerialPackager.UnpackUnsignedInteger
                                       unpackInt(width=10, nu=1)
    annotation (Placement(transformation(extent={{20,-4},{40,16}})));
  Modelica_DeviceDrivers.Blocks.Packaging.SerialPackager.PackUnsignedInteger
                                                                   packInt1(
      width=10, bitOffset=20,
    nu=1)
    annotation (Placement(transformation(extent={{-40,-34},{-20,-14}})));
  Modelica_DeviceDrivers.Blocks.Packaging.SerialPackager.AddInteger
                            addInteger1(n=1, nu=1)
    annotation (Placement(transformation(extent={{-40,-64},{-20,-44}})));
  Modelica.Blocks.Sources.IntegerExpression integerExpression1(y=integer(10*sin(
        time) + 10))
    annotation (Placement(transformation(extent={{-76,-34},{-56,-14}})));
  Modelica.Blocks.Sources.IntegerConstant integerConstant1(k=4)
    annotation (Placement(transformation(extent={{-74,-64},{-54,-44}})));
  Modelica_DeviceDrivers.Blocks.Packaging.SerialPackager.UnpackUnsignedInteger
                                       unpackInt1(width=10, bitOffset=20,
    nu=1)
    annotation (Placement(transformation(extent={{20,-34},{40,-14}})));
  Modelica_DeviceDrivers.Blocks.Packaging.SerialPackager.GetInteger
                       getInteger1(n=1)
    annotation (Placement(transformation(extent={{20,-70},{40,-50}})));
  Modelica_DeviceDrivers.Blocks.Packaging.SerialPackager.AddReal
                         addReal(n=3, nu=1)
    annotation (Placement(transformation(extent={{-40,30},{-20,50}})));
  Modelica_DeviceDrivers.Blocks.Packaging.SerialPackager.GetReal
                         getReal(n=3, nu=1)
    annotation (Placement(transformation(extent={{20,28},{40,48}})));
  Modelica.Blocks.Sources.RealExpression realExpression[3](y=sin(time)*{1,2,3})
    annotation (Placement(transformation(extent={{-76,30},{-56,50}})));
equation
  connect(integerExpression.y, packInt.u) annotation (Line(
      points={{-57,8},{-42,8}},
      color={255,127,0},
      smooth=Smooth.None));
  connect(integerExpression1.y, packInt1.u) annotation (Line(
      points={{-55,-24},{-42,-24}},
      color={255,127,0},
      smooth=Smooth.None));
  connect(integerConstant1.y,addInteger1. u[1]) annotation (Line(
      points={{-53,-54},{-42,-54}},
      color={255,127,0},
      smooth=Smooth.None));
  connect(realExpression.y, addReal.u) annotation (Line(
      points={{-55,40},{-42,40}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(packager.pkgOut, addReal.pkgIn) annotation (Line(
      points={{-30,61.2},{-30,50.8}},
      color={0,0,0},
      pattern=LinePattern.None,
      smooth=Smooth.None));
  connect(addReal.pkgOut[1], packInt.pkgIn) annotation (Line(
      points={{-30,29.2},{-30,18.8}},
      color={0,0,0},
      pattern=LinePattern.None,
      smooth=Smooth.None));
  connect(packInt.pkgOut[1], packInt1.pkgIn) annotation (Line(
      points={{-30,-2.8},{-30,-13.2}},
      color={0,0,0},
      pattern=LinePattern.None,
      smooth=Smooth.None));
  connect(packInt1.pkgOut[1], addInteger1.pkgIn) annotation (Line(
      points={{-30,-34.8},{-30,-43.2}},
      color={0,0,0},
      pattern=LinePattern.None,
      smooth=Smooth.None));
  connect(addInteger1.pkgOut[1], uDPSend.pkgIn) annotation (Line(
      points={{-30,-64.8},{-30,-77.2}},
      color={0,0,0},
      pattern=LinePattern.None,
      smooth=Smooth.None));
  connect(uDPReceive2_1.pkgOut, getReal.pkgIn) annotation (Line(
      points={{30,57.2},{30,48.8}},
      color={0,0,0},
      pattern=LinePattern.None,
      smooth=Smooth.None));
  connect(getReal.pkgOut[1], unpackInt.pkgIn) annotation (Line(
      points={{30,27.2},{30,16.8}},
      color={0,0,0},
      pattern=LinePattern.None,
      smooth=Smooth.None));
  connect(unpackInt.pkgOut[1], unpackInt1.pkgIn) annotation (Line(
      points={{30,-4.8},{30,-13.2}},
      color={0,0,0},
      pattern=LinePattern.None,
      smooth=Smooth.None));
  connect(unpackInt1.pkgOut[1], getInteger1.pkgIn) annotation (Line(
      points={{30,-34.8},{30,-49.2}},
      color={0,0,0},
      pattern=LinePattern.None,
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,
            -100},{100,100}}), graphics));
end TestSerialPackagerBitPack_UDP;
