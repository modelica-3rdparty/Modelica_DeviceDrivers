within Modelica_DeviceDrivers.Incubate.Examples;
model TestSerialPackager2 "Example for using the SerialPackager"
  import Modelica_DeviceDrivers;
extends Modelica.Icons.Example;
  Modelica_DeviceDrivers.Blocks.Packaging.SerialPackager.Packager packager(
    useBackwardSampleTimePropagation=false,
    sampleTime=0.1,
    useBackwardPropagatedBufferSize=false)
    annotation (Placement(transformation(extent={{-40,40},{-20,60}})));
  Modelica_DeviceDrivers.Blocks.Packaging.SerialPackager.AddInteger addInteger(nu=1)
    annotation (Placement(transformation(extent={{-40,-76},{-20,-56}})));
  Modelica.Blocks.Sources.IntegerExpression integerExpression2(y=integer(5*sin(
        time)))
    annotation (Placement(transformation(extent={{-76,-78},{-56,-58}})));
  Modelica_DeviceDrivers.Blocks.Packaging.SerialPackager.ResetPointer resetPointer(nu=1)
    annotation (Placement(transformation(extent={{36,36},{56,56}})));
  Modelica_DeviceDrivers.Blocks.Packaging.SerialPackager.AddString addString(nu=
       1, data="asdf")
    annotation (Placement(transformation(extent={{-40,-8},{-20,12}})));
  Modelica_DeviceDrivers.Blocks.Packaging.SerialPackager.GetString getString(nu=
       1) annotation (Placement(transformation(extent={{36,0},{56,20}})));
  Modelica_DeviceDrivers.Blocks.Packaging.SerialPackager.GetInteger getInteger
    annotation (Placement(transformation(extent={{36,-44},{56,-24}})));
equation
  connect(integerExpression2.y, addInteger.u[1]) annotation (Line(
      points={{-55,-68},{-48,-68},{-48,-66},{-42,-66}},
      color={255,127,0},
      smooth=Smooth.None));
  connect(addInteger.pkgOut[1], resetPointer.pkgIn) annotation (Line(
      points={{-30,-76.8},{-30,-86},{10,-86},{10,64},{46,64},{46,56.8}},
      color={0,0,0},
      pattern=LinePattern.None,
      smooth=Smooth.None));
  connect(packager.pkgOut, addString.pkgIn) annotation (Line(
      points={{-30,39.2},{-30,12.8}},
      color={0,0,0},
      pattern=LinePattern.None,
      smooth=Smooth.None));
  connect(addString.pkgOut[1], addInteger.pkgIn) annotation (Line(
      points={{-30,-8.8},{-30,-55.2}},
      color={0,0,0},
      pattern=LinePattern.None,
      smooth=Smooth.None));
  connect(resetPointer.pkgOut[1], getString.pkgIn) annotation (Line(
      points={{46,35.2},{46,20.8}},
      color={0,0,0},
      pattern=LinePattern.None,
      smooth=Smooth.None));
  connect(getString.pkgOut[1], getInteger.pkgIn) annotation (Line(
      points={{46,-0.8},{46,-23.2}},
      color={0,0,0},
      pattern=LinePattern.None,
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false,extent={{-100,
            -100},{100,100}}), graphics), experiment(StopTime=5.0),
    Documentation(info="<html>
<p>
The example demonstrates that pack and unpack blocks of the <code>SerialPackager</code> package can be connected directly.
</p>
</html>"));
end TestSerialPackager2;
