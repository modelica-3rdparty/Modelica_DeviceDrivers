within Modelica_DeviceDrivers.Blocks.Examples;
model TestSerialPackagerBitPack_UDP
  "Example for the PackUnsignedInteger and UnpackUnsignedInteger blocks from the SerialPackager"
extends Modelica.Icons.Example;
  Modelica_DeviceDrivers.Blocks.Communication.UDPSend
                                  uDPSend(port_send=10002)
                                                 annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={-30,-68})));
  Modelica.Blocks.Sources.IntegerExpression integerExpression(y=integer(5*sin(
        time) + 10))
    annotation (Placement(transformation(extent={{-84,4},{-50,24}})));
  Modelica_DeviceDrivers.Blocks.Packaging.SerialPackager.Packager
                          packager
    annotation (Placement(transformation(extent={{-40,56},{-20,76}})));
  Modelica_DeviceDrivers.Blocks.Packaging.SerialPackager.PackUnsignedInteger
                                                                   packInt(
      width=10, bitOffset=0,
    nu=1)
    annotation (Placement(transformation(extent={{-40,4},{-20,24}})));
  Modelica_DeviceDrivers.Blocks.Communication.UDPReceive uDPReceive(port_recv=
        10002)                                             annotation (
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
    annotation (Placement(transformation(extent={{-40,-24},{-20,-4}})));
  Modelica_DeviceDrivers.Blocks.Packaging.SerialPackager.AddInteger
                            addInteger1(n=1, nu=1)
    annotation (Placement(transformation(extent={{-40,-50},{-20,-30}})));
  Modelica.Blocks.Sources.IntegerExpression integerExpression1(y=integer(10*sin(
        time) + 10))
    annotation (Placement(transformation(extent={{-86,-24},{-50,-4}})));
  Modelica.Blocks.Sources.IntegerConstant integerConstant1(k=4)
    annotation (Placement(transformation(extent={{-70,-48},{-54,-32}})));
  Modelica_DeviceDrivers.Blocks.Packaging.SerialPackager.UnpackUnsignedInteger
                                       unpackInt1(width=10, bitOffset=20,
    nu=1)
    annotation (Placement(transformation(extent={{20,-34},{40,-14}})));
  Modelica_DeviceDrivers.Blocks.Packaging.SerialPackager.GetInteger
                       getInteger1(n=1)
    annotation (Placement(transformation(extent={{20,-64},{40,-44}})));
  Modelica_DeviceDrivers.Blocks.Packaging.SerialPackager.AddReal
                         addReal(n=3, nu=1)
    annotation (Placement(transformation(extent={{-40,30},{-20,50}})));
  Modelica_DeviceDrivers.Blocks.Packaging.SerialPackager.GetReal
                         getReal(n=3, nu=1)
    annotation (Placement(transformation(extent={{20,28},{40,48}})));
  Modelica.Blocks.Sources.RealExpression realExpression[3](y=sin(time)*{1,2,3})
    annotation (Placement(transformation(extent={{-74,30},{-50,50}})));
equation
  connect(integerExpression.y, packInt.u) annotation (Line(
      points={{-48.3,14},{-42,14}},
      color={255,127,0}));
  connect(integerExpression1.y, packInt1.u) annotation (Line(
      points={{-48.2,-14},{-42,-14}},
      color={255,127,0}));
  connect(integerConstant1.y,addInteger1. u[1]) annotation (Line(
      points={{-53.2,-40},{-42,-40}},
      color={255,127,0}));
  connect(realExpression.y, addReal.u) annotation (Line(
      points={{-48.8,40},{-42,40}},
      color={0,0,127}));
  connect(packager.pkgOut, addReal.pkgIn) annotation (Line(
      points={{-30,55.2},{-30,50.8}},
      pattern=LinePattern.None));
  connect(addReal.pkgOut[1], packInt.pkgIn) annotation (Line(
      points={{-30,29.2},{-30,24.8}},
      pattern=LinePattern.None));
  connect(packInt.pkgOut[1], packInt1.pkgIn) annotation (Line(
      points={{-30,3.2},{-30,-3.2}},
      pattern=LinePattern.None));
  connect(packInt1.pkgOut[1], addInteger1.pkgIn) annotation (Line(
      points={{-30,-24.8},{-30,-29.2}},
      pattern=LinePattern.None));
  connect(addInteger1.pkgOut[1], uDPSend.pkgIn) annotation (Line(
      points={{-30,-50.8},{-30,-57.2}},
      pattern=LinePattern.None));
  connect(uDPReceive.pkgOut, getReal.pkgIn)    annotation (Line(
      points={{30,57.2},{30,48.8}},
      pattern=LinePattern.None));
  connect(getReal.pkgOut[1], unpackInt.pkgIn) annotation (Line(
      points={{30,27.2},{30,16.8}},
      pattern=LinePattern.None));
  connect(unpackInt.pkgOut[1], unpackInt1.pkgIn) annotation (Line(
      points={{30,-4.8},{30,-13.2}},
      pattern=LinePattern.None));
  connect(unpackInt1.pkgOut[1], getInteger1.pkgIn) annotation (Line(
      points={{30,-34.8},{30,-43.2}},
      pattern=LinePattern.None));
  annotation (experiment(StopTime=5.0),
    Documentation(info="<html>
<p>
In particular this model demonstrates how integer values can be packed and unpacked at bit level using the <a href=\"modelica://Modelica_DeviceDrivers.Blocks.Packaging.SerialPackager.PackUnsignedInteger\"> <code>PackUnsignedInteger</code></a> and <a href=\"modelica://Modelica_DeviceDrivers.Blocks.Packaging.SerialPackager.UnpackUnsignedInteger\"><code>UnpackUnsignedInteger</code></a> blocks.
</p>
</html>"));
end TestSerialPackagerBitPack_UDP;
