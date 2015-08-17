within Modelica_DeviceDrivers.Blocks.Examples;
model TestSerialPackager_ExternalTrigger
  "Example for using the external trigger feature"
extends Modelica.Icons.Example;
  Modelica.Blocks.Sources.IntegerExpression iExp(y=integer(3*sin(time) + 3))
    annotation (Placement(transformation(extent={{-80,0},{-60,20}})));
  Packaging.SerialPackager.Packager
                          packager(useBackwardSampleTimePropagation=false,
      sampleTime=0.1,
    enableExternalTrigger=true)
    annotation (Placement(transformation(extent={{-40,40},{-20,60}})));
  Packaging.SerialPackager.PackUnsignedInteger packInt(nu=1, width=10)
    annotation (Placement(transformation(extent={{-40,0},{-20,20}})));
  Packaging.SerialPackager.AddInteger addInteger(nu=1)
    annotation (Placement(transformation(extent={{-40,-76},{-20,-56}})));
  Modelica.Blocks.Sources.IntegerExpression iExp3(y=integer(5*sin(time)))
    annotation (Placement(transformation(extent={{-76,-76},{-56,-56}})));
  Modelica.Blocks.Sources.IntegerExpression iExp2(y=integer(5*sin(time) + 5))
    annotation (Placement(transformation(extent={{-80,-38},{-60,-18}})));
  Packaging.SerialPackager.PackUnsignedInteger packInt1(nu=1,
    bitOffset=5,
    width=10)
    annotation (Placement(transformation(extent={{-40,-38},{-20,-18}})));
  Packaging.SerialPackager.ResetPointer resetPointer(nu=1)
    annotation (Placement(transformation(extent={{36,36},{56,56}})));
  Packaging.SerialPackager.UnpackUnsignedInteger unpackInt(nu=1, width=10)
    annotation (Placement(transformation(extent={{36,2},{56,22}})));
  Packaging.SerialPackager.GetInteger getInteger
    annotation (Placement(transformation(extent={{36,-72},{56,-52}})));
  Packaging.SerialPackager.UnpackUnsignedInteger unpackInt1(
    nu=1,
    bitOffset=5,
    width=10) annotation (Placement(transformation(extent={{36,-34},{56,-14}})));
  Modelica.Blocks.Sources.BooleanExpression trig(y=change(iExp.y))
    annotation (Placement(transformation(extent={{-90,38},{-60,60}})));
equation
  connect(iExp.y, packInt.u)
    annotation (Line(points={{-59,10},{-42,10}}, color={255,127,0}));
  connect(packager.pkgOut, packInt.pkgIn) annotation (Line(
      points={{-30,39.2},{-30,20.8}}));
  connect(iExp3.y, addInteger.u[1]) annotation (Line(points={{-55,-66},{-48,-66},
          {-42,-66}}, color={255,127,0}));
  connect(iExp2.y, packInt1.u)
    annotation (Line(points={{-59,-28},{-42,-28}}, color={255,127,0}));
  connect(packInt.pkgOut[1], packInt1.pkgIn) annotation (Line(
      points={{-30,-0.8},{-30,-17.2}}));
  connect(packInt1.pkgOut[1], addInteger.pkgIn) annotation (Line(
      points={{-30,-38.8},{-30,-55.2}}));
  connect(addInteger.pkgOut[1], resetPointer.pkgIn) annotation (Line(
      points={{-30,-76.8},{-30,-86},{10,-86},{10,64},{46,64},{46,56.8}}));
  connect(resetPointer.pkgOut[1], unpackInt.pkgIn) annotation (Line(
      points={{46,35.2},{46,22.8}}));
  connect(unpackInt.pkgOut[1], unpackInt1.pkgIn) annotation (Line(
      points={{46,1.2},{46,-13.2}}));
  connect(unpackInt1.pkgOut[1], getInteger.pkgIn) annotation (Line(
      points={{46,-34.8},{46,-51.2}}));
  connect(trig.y, packager.trigger) annotation (Line(
      points={{-58.5,49},{-50.25,49},{-50.25,50},{-42,50}},
      color={255,0,255}));
  annotation (experiment(StopTime=5.0),
    Documentation(info="<html>
<p>
The example demonstrates that pack and unpack blocks of the <code>SerialPackager</code> package can be connected directly.
</p>
</html>"));
end TestSerialPackager_ExternalTrigger;
