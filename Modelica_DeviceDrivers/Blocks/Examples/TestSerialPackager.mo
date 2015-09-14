within Modelica_DeviceDrivers.Blocks.Examples;
model TestSerialPackager "Example for using the SerialPackager"
extends Modelica.Icons.Example;
  Modelica.Blocks.Sources.IntegerExpression integerExpression(y=integer(3*sin(
        time) + 3))
    annotation (Placement(transformation(extent={{-84,30},{-64,50}})));
  Packaging.SerialPackager.Packager
                          packager(useBackwardSampleTimePropagation=false,
      sampleTime=0.1)
    annotation (Placement(transformation(extent={{-44,70},{-24,90}})));
  Packaging.SerialPackager.PackUnsignedInteger packInt(nu=1, width=10)
    annotation (Placement(transformation(extent={{-44,30},{-24,50}})));
  Packaging.SerialPackager.AddInteger addInteger(nu=1)
    annotation (Placement(transformation(extent={{-44,-46},{-24,-26}})));
  Modelica.Blocks.Sources.IntegerExpression integerExpression2(y=integer(5*sin(
        time)))
    annotation (Placement(transformation(extent={{-80,-48},{-60,-28}})));
  Modelica.Blocks.Sources.IntegerExpression integerExpression1(y=integer(5*sin(
        time) + 5))
    annotation (Placement(transformation(extent={{-84,-8},{-64,12}})));
  Packaging.SerialPackager.PackUnsignedInteger packInt1(nu=1,
    bitOffset=5,
    width=10)
    annotation (Placement(transformation(extent={{-44,-8},{-24,12}})));
  Packaging.SerialPackager.ResetPointer resetPointer(nu=1)
    annotation (Placement(transformation(extent={{32,66},{52,86}})));
  Packaging.SerialPackager.UnpackUnsignedInteger unpackInt(nu=1, width=10)
    annotation (Placement(transformation(extent={{32,32},{52,52}})));
  Packaging.SerialPackager.GetInteger getInteger(nu=1)
    annotation (Placement(transformation(extent={{32,-42},{52,-22}})));
  Packaging.SerialPackager.UnpackUnsignedInteger unpackInt1(
    nu=1,
    bitOffset=5,
    width=10) annotation (Placement(transformation(extent={{32,-4},{52,16}})));
  Packaging.SerialPackager.AddBoolean addBoolean(nu=1)
    annotation (Placement(transformation(extent={{-44,-78},{-24,-58}})));
  Packaging.SerialPackager.GetBoolean getBoolean
    annotation (Placement(transformation(extent={{32,-76},{52,-56}})));
  Modelica.Blocks.Sources.BooleanPulse booleanPulse(period=0.2)
    annotation (Placement(transformation(extent={{-80,-78},{-60,-58}})));
equation
  connect(integerExpression.y, packInt.u) annotation (Line(
      points={{-63,40},{-46,40}},
      color={255,127,0}));
  connect(packager.pkgOut, packInt.pkgIn) annotation (Line(
      points={{-34,69.2},{-34,50.8}}));
  connect(integerExpression2.y, addInteger.u[1]) annotation (Line(
      points={{-59,-38},{-52,-38},{-52,-36},{-46,-36}},
      color={255,127,0}));
  connect(integerExpression1.y, packInt1.u) annotation (Line(
      points={{-63,2},{-46,2}},
      color={255,127,0}));
  connect(packInt.pkgOut[1], packInt1.pkgIn) annotation (Line(
      points={{-34,29.2},{-34,12.8}}));
  connect(packInt1.pkgOut[1], addInteger.pkgIn) annotation (Line(
      points={{-34,-8.8},{-34,-25.2}}));
  connect(resetPointer.pkgOut[1], unpackInt.pkgIn) annotation (Line(
      points={{42,65.2},{42,52.8}}));
  connect(unpackInt.pkgOut[1], unpackInt1.pkgIn) annotation (Line(
      points={{42,31.2},{42,16.8}}));
  connect(unpackInt1.pkgOut[1], getInteger.pkgIn) annotation (Line(
      points={{42,-4.8},{42,-21.2}}));
  connect(booleanPulse.y, addBoolean.u[1]) annotation (Line(
      points={{-59,-68},{-46,-68}},
      color={255,0,255},
      smooth=Smooth.None));
  connect(addInteger.pkgOut[1], addBoolean.pkgIn) annotation (Line(
      points={{-34,-46.8},{-34,-57.2}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(getInteger.pkgOut[1], getBoolean.pkgIn) annotation (Line(
      points={{42,-42.8},{42,-55.2}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(addBoolean.pkgOut[1], resetPointer.pkgIn) annotation (Line(
      points={{-34,-78.8},{-34,-84},{0,-84},{0,94},{42,94},{42,86.8}},
      color={0,0,0},
      smooth=Smooth.None));
  annotation (experiment(StopTime=5.0),
    Documentation(info="<html>
<p>
The example demonstrates that pack and unpack blocks of the <code>SerialPackager</code> package can be connected directly.
</p>
</html>"));
end TestSerialPackager;
