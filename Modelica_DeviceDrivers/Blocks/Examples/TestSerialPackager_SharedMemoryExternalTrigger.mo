within Modelica_DeviceDrivers.Blocks.Examples;
model TestSerialPackager_SharedMemoryExternalTrigger
  "Example for combining externally triggered SharedMemory and SerialPackager blocks"
extends Modelica.Icons.Example;
  Packaging.SerialPackager.Packager
                     packager
    annotation (Placement(transformation(extent={{-40,66},{-20,86}})));
  Packaging.SerialPackager.AddReal
                    addReal(n=3, nu=1)
    annotation (Placement(transformation(extent={{-40,26},{-20,46}})));
  Modelica.Blocks.Sources.RealExpression realExpression[3](y=sin(time)*{1,2,3})
    annotation (Placement(transformation(extent={{-80,26},{-60,46}})));
  Packaging.SerialPackager.AddInteger
                       addInteger(nu=1)
    annotation (Placement(transformation(extent={{-40,-14},{-20,6}})));
  Modelica.Blocks.Sources.IntegerExpression integerExpression(y=integer(10*sin(
        time)))
    annotation (Placement(transformation(extent={{-80,-14},{-60,6}})));
  Communication.SharedMemoryWrite sharedMemoryWrite(enableExternalTrigger=true)
                                                    annotation (Placement(
        transformation(
        extent={{-10,10},{10,-10}},
        rotation=270,
        origin={-30,-42})));
  Packaging.SerialPackager.GetReal
                    getReal(n=3, nu=1)
    annotation (Placement(transformation(extent={{40,-2},{60,18}})));
  Packaging.SerialPackager.GetInteger
                       getInteger
    annotation (Placement(transformation(extent={{40,-42},{60,-22}})));
  Communication.SharedMemoryRead sharedMemoryRead(enableExternalTrigger=true)
                                                  annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={50,68})));
  Modelica.Blocks.Logical.ZeroCrossing zeroCrossing1 annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={0,-72})));
  Modelica.Blocks.Sources.BooleanExpression enable(y=true)
    annotation (Placement(transformation(extent={{44,-82},{24,-62}})));
  Modelica.Blocks.Sources.RealExpression realExpression1(y=sin(4*time))
    annotation (Placement(transformation(extent={{-40,-100},{-20,-80}})));
equation
  connect(integerExpression.y, addInteger.u[1]) annotation (Line(
      points={{-59,-4},{-42,-4}},
      color={255,127,0}));
  connect(realExpression.y, addReal.u) annotation (Line(
      points={{-59,36},{-42,36}},
      color={0,0,127}));
  connect(packager.pkgOut, addReal.pkgIn) annotation (Line(
      points={{-30,65.2},{-30,46.8}}));
  connect(addReal.pkgOut[1], addInteger.pkgIn) annotation (Line(
      points={{-30,25.2},{-30,6.8}}));
  connect(addInteger.pkgOut[1], sharedMemoryWrite.pkgIn) annotation (Line(
      points={{-30,-14.8},{-30,-31.2}}));
  connect(sharedMemoryRead.pkgOut, getReal.pkgIn) annotation (Line(
      points={{50,57.2},{50,18.8}}));
  connect(getReal.pkgOut[1], getInteger.pkgIn) annotation (Line(
      points={{50,-2.8},{50,-21.2}}));
  connect(enable.y, zeroCrossing1.enable) annotation (Line(
      points={{23,-72},{12,-72}},
      color={255,0,255},
      smooth=Smooth.None));
  connect(zeroCrossing1.y, sharedMemoryWrite.trigger) annotation (Line(
      points={{6.66134e-16,-61},{6.66134e-16,-42},{-18,-42}},
      color={255,0,255},
      smooth=Smooth.None));
  connect(zeroCrossing1.y, sharedMemoryRead.trigger) annotation (Line(
      points={{6.66134e-16,-61},{6.66134e-16,68},{38,68}},
      color={255,0,255},
      smooth=Smooth.None));
  connect(realExpression1.y, zeroCrossing1.u) annotation (Line(
      points={{-19,-90},{0,-90},{0,-84}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (experiment(StopTime=5.0),
    Documentation(info="<html>
<p>
The <code>sharedMemoryWrite</code> block writes to the memory partition with <code>memoryID = \"sharedMemory\"</code>. The <code>sharedMemoryRead</code> block reads from that partition.
</p>
<p>
<b>Note:</b> There is no causality between the <code>sharedMemoryWrite</code> block and the <code>sharedMemoryRead</code> block. Therefore the execution order of the blocks is not determined. This indeterminism may also show up in the plots.
</p>
</html>"),
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{
            100,100}}), graphics));
end TestSerialPackager_SharedMemoryExternalTrigger;
