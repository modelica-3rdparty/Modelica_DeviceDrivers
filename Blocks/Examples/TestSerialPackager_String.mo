within Modelica_DeviceDrivers.Blocks.Examples;
model TestSerialPackager_String
  "Example for using the SerialPackager with the AddString and GetString block"
extends Modelica.Icons.Example;
  Modelica.Blocks.Sources.IntegerExpression integerExpression(y=integer(3*sin(
        time) + 3))
    annotation (Placement(transformation(extent={{-92,18},{-72,38}})));
  Packaging.SerialPackager.Packager
                          packager(useBackwardSampleTimePropagation=false,
      sampleTime=0.1,
    useBackwardPropagatedBufferSize=true)
    annotation (Placement(transformation(extent={{-54,58},{-34,78}})));
  Packaging.SerialPackager.PackUnsignedInteger packInt(      width=10, nu=1)
    annotation (Placement(transformation(extent={{-54,18},{-34,38}})));
  Packaging.SerialPackager.AddInteger addInteger(nu=1)
    annotation (Placement(transformation(extent={{-54,-42},{-34,-22}})));
  Modelica.Blocks.Sources.IntegerExpression integerExpression2(y=integer(5*sin(
        time)))
    annotation (Placement(transformation(extent={{-92,-42},{-72,-22}})));
  Packaging.SerialPackager.ResetPointer resetPointer(nu=1)
    annotation (Placement(transformation(extent={{-6,54},{14,74}})));
  Packaging.SerialPackager.UnpackUnsignedInteger unpackInt(      width=10, nu=1)
    annotation (Placement(transformation(extent={{-6,20},{14,40}})));
  Packaging.SerialPackager.GetInteger getInteger
    annotation (Placement(transformation(extent={{-6,-42},{14,-22}})));
  Packaging.SerialPackager.AddString addString(nu=1, data=stringEx.y)
    annotation (Placement(transformation(extent={{-54,-12},{-34,8}})));
  Packaging.SerialPackager.GetString getString(nu=1)
    annotation (Placement(transformation(extent={{-6,-12},{14,8}})));
  Modelica.Blocks.Sources.IntegerExpression findString(y=
        Modelica.Utilities.Strings.find(getString.data, "examp"))
    annotation (Placement(transformation(extent={{18,-14},{92,10}})));
  Utilities.StringExpression stringEx
    annotation (Placement(transformation(extent={{-92,-10},{-64,8}})));
equation
  connect(integerExpression.y, packInt.u) annotation (Line(
      points={{-71,28},{-56,28}},
      color={255,127,0},
      smooth=Smooth.None));
  connect(packager.pkgOut, packInt.pkgIn) annotation (Line(
      points={{-44,57.2},{-44,38.8}},
      color={0,0,0},
      pattern=LinePattern.None,
      smooth=Smooth.None));
  connect(integerExpression2.y, addInteger.u[1]) annotation (Line(
      points={{-71,-32},{-56,-32}},
      color={255,127,0},
      smooth=Smooth.None));
  connect(resetPointer.pkgOut[1], unpackInt.pkgIn) annotation (Line(
      points={{4,53.2},{4,40.8}},
      color={0,0,0},
      pattern=LinePattern.None,
      smooth=Smooth.None));
  connect(addString.pkgOut[1], addInteger.pkgIn) annotation (Line(
      points={{-44,-12.8},{-44,-21.2}},
      color={0,0,0},
      pattern=LinePattern.None,
      smooth=Smooth.None));
  connect(packInt.pkgOut[1], addString.pkgIn) annotation (Line(
      points={{-44,17.2},{-44,8.8}},
      color={0,0,0},
      pattern=LinePattern.None,
      smooth=Smooth.None));
  connect(unpackInt.pkgOut[1], getString.pkgIn) annotation (Line(
      points={{4,19.2},{4,8.8}},
      color={0,0,0},
      pattern=LinePattern.None,
      smooth=Smooth.None));
  connect(getString.pkgOut[1], getInteger.pkgIn) annotation (Line(
      points={{4,-12.8},{4,-21.2}},
      color={0,0,0},
      pattern=LinePattern.None,
      smooth=Smooth.None));
  connect(addInteger.pkgOut[1], resetPointer.pkgIn) annotation (Line(
      points={{-44,-42.8},{-44,-50},{-14,-50},{-14,82},{4,82},{4,74.8}},
      color={0,0,0},
      pattern=LinePattern.None,
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false,extent={{-100,-100},
            {100,100}}),       graphics), experiment(StopTime=5.0),
    Documentation(info="<html>
<p>
Using Strings in input or output connectors is not very common in Modelica. There are currently no standard connectors for
Strings available in the MSL. Nevertheless, the <code>SerialPackager</code> package provides blocks for Strings, too. The use of this blocks
is demonstrated in this example.
</p>
</html>"));
end TestSerialPackager_String;
