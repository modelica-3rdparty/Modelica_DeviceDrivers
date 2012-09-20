within Modelica_DeviceDrivers.Incubate;
model TestLogging
extends Modelica.Icons.Example;
  Modelica_DeviceDrivers.Incubate.Blocks.Logging.LogVector
                    logVector(filename="test.txt", n=3)
    annotation (Placement(transformation(extent={{-20,-20},{0,0}})));
  Modelica.Blocks.Sources.RealExpression realExpression[3](y=ones(3)*sin(time))
    annotation (Placement(transformation(extent={{-80,-20},{-60,0}})));
equation
  connect(realExpression.y, logVector.u) annotation (Line(
      points={{-59,-10},{-22,-10}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (Diagram(graphics));
end TestLogging;
