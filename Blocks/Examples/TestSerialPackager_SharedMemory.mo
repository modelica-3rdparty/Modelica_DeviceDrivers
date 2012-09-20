within Modelica_DeviceDrivers.Blocks.Examples;
model TestSerialPackager_SharedMemory
extends Modelica.Icons.Example;
  Packaging.SerialPackager.Packager
                     packager
    annotation (Placement(transformation(extent={{-40,40},{-20,60}})));
  Packaging.SerialPackager.AddReal
                    addReal(n=3, nu=1)
    annotation (Placement(transformation(extent={{-40,0},{-20,20}})));
  Modelica.Blocks.Sources.RealExpression realExpression[3](y=sin(time)*{1,2,3})
    annotation (Placement(transformation(extent={{-80,0},{-60,20}})));
  Packaging.SerialPackager.AddInteger
                       addInteger(nu=1)
    annotation (Placement(transformation(extent={{-40,-40},{-20,-20}})));
  Modelica.Blocks.Sources.IntegerExpression integerExpression(y=integer(10*sin(
        time)))
    annotation (Placement(transformation(extent={{-80,-40},{-60,-20}})));
  Communication.SharedMemoryWrite sharedMemoryWrite annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={-30,-70})));
  Packaging.SerialPackager.GetReal
                    getReal(n=3, nu=1)
    annotation (Placement(transformation(extent={{40,-20},{60,0}})));
  Packaging.SerialPackager.GetInteger
                       getInteger
    annotation (Placement(transformation(extent={{40,-60},{60,-40}})));
  Communication.SharedMemoryRead sharedMemoryRead annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={50,50})));
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
  connect(addInteger.pkgOut[1], sharedMemoryWrite.pkgIn) annotation (Line(
      points={{-30,-40.8},{-30,-59.2}},
      color={0,0,0},
      pattern=LinePattern.None,
      smooth=Smooth.None));
  connect(sharedMemoryRead.pkgOut, getReal.pkgIn) annotation (Line(
      points={{50,39.2},{50,0.8}},
      color={0,0,0},
      pattern=LinePattern.None,
      smooth=Smooth.None));
  connect(getReal.pkgOut[1], getInteger.pkgIn) annotation (Line(
      points={{50,-20.8},{50,-39.2}},
      color={0,0,0},
      pattern=LinePattern.None,
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,
            -100},{100,100}}), graphics), experiment(StopTime=1.1));
end TestSerialPackager_SharedMemory;
