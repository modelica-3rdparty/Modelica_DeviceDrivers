within Modelica_DeviceDrivers.Blocks.Examples;
model TestSerialPackager_UDP
extends Modelica.Icons.Example;
  Modelica_DeviceDrivers.Blocks.Packaging.SerialPackager.Packager
                     packager
    annotation (Placement(transformation(extent={{-40,40},{-20,60}})));
  Modelica_DeviceDrivers.Blocks.Packaging.SerialPackager.AddReal
                    addReal(n=3, nu=1)
    annotation (Placement(transformation(extent={{-40,0},{-20,20}})));
  Modelica.Blocks.Sources.RealExpression realExpression[3](y=sin(time)*{1,2,3})
    annotation (Placement(transformation(extent={{-80,0},{-60,20}})));
  Modelica_DeviceDrivers.Blocks.Communication.UDPSend
                                  uDPSend(port_send=10002)
                                                 annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={-30,-70})));
  Modelica_DeviceDrivers.Blocks.Packaging.SerialPackager.AddInteger
                       addInteger(nu=1)
    annotation (Placement(transformation(extent={{-40,-40},{-20,-20}})));
  Modelica.Blocks.Sources.IntegerExpression integerExpression(y=integer(10*sin(
        time)))
    annotation (Placement(transformation(extent={{-80,-40},{-60,-20}})));
  Modelica_DeviceDrivers.Blocks.Communication.UDPReceive
                                 uDPReceive(port_recv=10002)
                                      annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={40,50})));
  Modelica_DeviceDrivers.Blocks.Packaging.SerialPackager.GetReal
                    getReal(n=3, nu=1)
    annotation (Placement(transformation(extent={{30,0},{50,20}})));
  Modelica_DeviceDrivers.Blocks.Packaging.SerialPackager.GetInteger
                       getInteger
    annotation (Placement(transformation(extent={{30,-40},{50,-20}})));
equation
  connect(integerExpression.y, addInteger.u[1]) annotation (Line(
      points={{-59,-30},{-42,-30}},
      color={255,127,0},
      pattern=LinePattern.None,
      smooth=Smooth.None));
  connect(realExpression.y, addReal.u) annotation (Line(
      points={{-59,10},{-42,10}},
      color={0,0,127},
      pattern=LinePattern.None,
      smooth=Smooth.None));
  connect(packager.pkgOut, addReal.pkgIn) annotation (Line(
      points={{-30,39.2},{-30,20.8}},
      color={0,0,0},
      pattern=LinePattern.None,
      smooth=Smooth.None));
  connect(addReal.pkgOut[1], addInteger.pkgIn) annotation (Line(
      points={{-30,-0.8},{-30,-19.2}},
      color={0,0,0},
      pattern=LinePattern.None,
      smooth=Smooth.None));
  connect(addInteger.pkgOut[1], uDPSend.pkgIn) annotation (Line(
      points={{-30,-40.8},{-30,-59.2}},
      color={0,0,0},
      pattern=LinePattern.None,
      smooth=Smooth.None));
  connect(uDPReceive.pkgOut, getReal.pkgIn) annotation (Line(
      points={{40,39.2},{40,20.8}},
      color={0,0,0},
      pattern=LinePattern.None,
      smooth=Smooth.None));
  connect(getReal.pkgOut[1], getInteger.pkgIn) annotation (Line(
      points={{40,-0.8},{40,-19.2}},
      color={0,0,0},
      pattern=LinePattern.None,
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,
            -100},{100,100}}), graphics), experiment(StopTime=1.1));
end TestSerialPackager_UDP;
