within Modelica_DeviceDrivers.Blocks.Examples;
model TestSerialPackagerMinimal
extends Modelica.Icons.Example;
  Modelica.Blocks.Sources.IntegerExpression integerExpression(y=integer(3*sin(
        time) + 3))
    annotation (Placement(transformation(extent={{-80,0},{-60,20}})));
  Packaging.SerialPackager.Packager
                          packager(useBackwardSampleTimePropagation=false,
      sampleTime=0.1)
    annotation (Placement(transformation(extent={{-40,40},{-20,60}})));
  Packaging.SerialPackager.PackUnsignedInteger packInt(      width=10)
    annotation (Placement(transformation(extent={{-40,0},{-20,20}})));
equation
  connect(integerExpression.y, packInt.u) annotation (Line(
      points={{-59,10},{-42,10}},
      color={255,127,0},
      smooth=Smooth.None));
  connect(packager.pkgOut, packInt.pkgIn) annotation (Line(
      points={{-30,39.2},{-30,20.8}},
      color={0,0,0},
      pattern=LinePattern.None,
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,
            -100},{100,100}}), graphics), experiment(StopTime=1.1));
end TestSerialPackagerMinimal;
