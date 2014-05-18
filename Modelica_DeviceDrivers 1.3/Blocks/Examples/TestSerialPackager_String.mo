within Modelica_DeviceDrivers.Blocks.Examples;
model TestSerialPackager_String
  "Example for using the SerialPackager with the AddString and GetString block"
extends Modelica.Icons.Example;
  Modelica.Blocks.Sources.IntegerExpression integerExpression(y=integer(3*sin(
        time) + 3))
    annotation (Placement(transformation(extent={{-90,2},{-70,22}})));
  Packaging.SerialPackager.Packager
                          packager(useBackwardSampleTimePropagation=false,
      sampleTime=0.1,
    useBackwardPropagatedBufferSize=true)
    annotation (Placement(transformation(extent={{-52,42},{-32,62}})));
  Packaging.SerialPackager.PackUnsignedInteger packInt(      width=10, nu=1)
    annotation (Placement(transformation(extent={{-52,2},{-32,22}})));
  Packaging.SerialPackager.AddInteger addInteger(nu=1)
    annotation (Placement(transformation(extent={{-52,-58},{-32,-38}})));
  Modelica.Blocks.Sources.IntegerExpression integerExpression2(y=integer(5*sin(
        time)))
    annotation (Placement(transformation(extent={{-90,-58},{-70,-38}})));
  Packaging.SerialPackager.ResetPointer resetPointer(nu=1)
    annotation (Placement(transformation(extent={{-4,38},{16,58}})));
  Packaging.SerialPackager.UnpackUnsignedInteger unpackInt(      width=10, nu=1)
    annotation (Placement(transformation(extent={{-4,4},{16,24}})));
  Packaging.SerialPackager.GetInteger getInteger
    annotation (Placement(transformation(extent={{-4,-58},{16,-38}})));
  Packaging.SerialPackager.AddString addString(nu=1, data=stringEx.y)
    annotation (Placement(transformation(extent={{-52,-28},{-32,-8}})));
  Packaging.SerialPackager.GetString getString(nu=1)
    annotation (Placement(transformation(extent={{-4,-28},{16,-8}})));
  Modelica.Blocks.Sources.IntegerExpression findString(y=
        Modelica.Utilities.Strings.find(getString.data, "examp"))
    annotation (Placement(transformation(extent={{20,-30},{94,-6}})));
  Utilities.StringExpression stringEx
    annotation (Placement(transformation(extent={{-90,-26},{-62,-8}})));
equation
  connect(integerExpression.y, packInt.u) annotation (Line(
      points={{-69,12},{-54,12}},
      color={255,127,0}));
  connect(packager.pkgOut, packInt.pkgIn) annotation (Line(
      points={{-42,41.2},{-42,22.8}},
      pattern=LinePattern.None));
  connect(integerExpression2.y, addInteger.u[1]) annotation (Line(
      points={{-69,-48},{-54,-48}},
      color={255,127,0}));
  connect(resetPointer.pkgOut[1], unpackInt.pkgIn) annotation (Line(
      points={{6,37.2},{6,24.8}},
      pattern=LinePattern.None));
  connect(addString.pkgOut[1], addInteger.pkgIn) annotation (Line(
      points={{-42,-28.8},{-42,-37.2}},
      pattern=LinePattern.None));
  connect(packInt.pkgOut[1], addString.pkgIn) annotation (Line(
      points={{-42,1.2},{-42,-7.2}},
      pattern=LinePattern.None));
  connect(unpackInt.pkgOut[1], getString.pkgIn) annotation (Line(
      points={{6,3.2},{6,-7.2}},
      pattern=LinePattern.None));
  connect(getString.pkgOut[1], getInteger.pkgIn) annotation (Line(
      points={{6,-28.8},{6,-37.2}},
      pattern=LinePattern.None));
  connect(addInteger.pkgOut[1], resetPointer.pkgIn) annotation (Line(
      points={{-42,-58.8},{-42,-66},{-12,-66},{-12,66},{6,66},{6,58.8}},
      pattern=LinePattern.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false,extent={{-100,
            -100},{100,100}}), graphics={Text(
          extent={{-82,84},{82,68}},
          lineColor={0,0,255},
          textString=
              "Please have look at the documentation to this model before executing.")}),
                                          experiment(StopTime=5.0),
    Documentation(info="<html>
<p>Using Strings in input or output connectors is not very common in Modelica. There are currently no standard connectors for Strings available in the MSL. Nevertheless, the <code>SerialPackager</code> package provides blocks for Strings, too. The use of this blocks is demonstrated in this example.</p>
<p><b>Please note: </b>The model should work with Dymola 2014, but seems not with Dymola 2013 FD01 (and probably previous versions).</p>
</html>"));
end TestSerialPackager_String;
