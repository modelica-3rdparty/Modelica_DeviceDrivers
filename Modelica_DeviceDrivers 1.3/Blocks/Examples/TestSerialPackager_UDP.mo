within Modelica_DeviceDrivers.Blocks.Examples;
model TestSerialPackager_UDP
  "Example for combining UDP and SerialPackager blocks"
extends Modelica.Icons.Example;
  Modelica_DeviceDrivers.Blocks.Packaging.SerialPackager.Packager
                     packager
    annotation (Placement(transformation(extent={{-40,62},{-20,82}})));
  Modelica_DeviceDrivers.Blocks.Packaging.SerialPackager.AddReal
                    addReal(n=3, nu=1)
    annotation (Placement(transformation(extent={{-40,34},{-20,54}})));
  Modelica.Blocks.Sources.RealExpression realExpression[3](y=sin(time)*{1,2,3})
    annotation (Placement(transformation(extent={{-80,34},{-60,54}})));
  Modelica_DeviceDrivers.Blocks.Communication.UDPSend
                                  uDPSend(port_send=10002)
                                                 annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={-30,-44})));
  Modelica_DeviceDrivers.Blocks.Packaging.SerialPackager.AddInteger
                       addInteger(nu=1)
    annotation (Placement(transformation(extent={{-40,-26},{-20,-6}})));
  Modelica.Blocks.Sources.IntegerExpression integerExpression(y=integer(10*sin(
        time)))
    annotation (Placement(transformation(extent={{-80,-26},{-60,-6}})));
  Modelica_DeviceDrivers.Blocks.Communication.UDPReceive
                                 uDPReceive(port_recv=10002)
                                      annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={40,50})));
  Modelica_DeviceDrivers.Blocks.Packaging.SerialPackager.GetReal
                    getReal(n=3, nu=1)
    annotation (Placement(transformation(extent={{30,10},{50,30}})));
  Modelica_DeviceDrivers.Blocks.Packaging.SerialPackager.GetInteger
                       getInteger
    annotation (Placement(transformation(extent={{30,-48},{50,-28}})));
  Packaging.SerialPackager.AddFloat addFloat(n=2, nu=1)
    annotation (Placement(transformation(extent={{-40,2},{-20,22}})));
  Packaging.SerialPackager.GetFloat getFloat(n=2, nu=1)
    annotation (Placement(transformation(extent={{30,-18},{50,2}})));
  Modelica.Blocks.Sources.RealExpression realExpression1[2](y=sin(time)*{1,2})
    annotation (Placement(transformation(extent={{-78,2},{-58,22}})));
equation
  connect(integerExpression.y, addInteger.u[1]) annotation (Line(
      points={{-59,-16},{-42,-16}},
      color={255,127,0},
      pattern=LinePattern.None));
  connect(realExpression.y, addReal.u) annotation (Line(
      points={{-59,44},{-42,44}},
      color={0,0,127},
      pattern=LinePattern.None));
  connect(packager.pkgOut, addReal.pkgIn) annotation (Line(
      points={{-30,61.2},{-30,54.8}},
      pattern=LinePattern.None));
  connect(uDPReceive.pkgOut, getReal.pkgIn) annotation (Line(
      points={{40,39.2},{40,30.8}},
      pattern=LinePattern.None));
  connect(realExpression1.y, addFloat.u) annotation (Line(
      points={{-57,12},{-42,12}},
      color={0,0,127}));
  connect(addReal.pkgOut[1], addFloat.pkgIn) annotation (Line(
      points={{-30,33.2},{-30,22.8}},
      pattern=LinePattern.None));
  connect(addFloat.pkgOut[1], addInteger.pkgIn) annotation (Line(
      points={{-30,1.2},{-30,-5.2}},
      pattern=LinePattern.None));
  connect(uDPSend.pkgIn, addInteger.pkgOut[1]) annotation (Line(
      points={{-30,-33.2},{-30,-26.8}},
      pattern=LinePattern.None));
  connect(getReal.pkgOut[1], getFloat.pkgIn) annotation (Line(
      points={{40,9.2},{40,2.8}},
      pattern=LinePattern.None));
  connect(getInteger.pkgIn, getFloat.pkgOut[1]) annotation (Line(
      points={{40,-27.2},{40,-18.8}},
      pattern=LinePattern.None));
  annotation (experiment(StopTime=5.0),
    Documentation(info="<html>
<p>
The <code>uDPSend</code> block sends to the local port 10002. The <code>uDPReceive</code> block starts a background process that listens at port 10002. Consequently, the <code>uDPReceive</code> block receives what the <code>uDPSend</code> block sends.
</p>
<p>
<b>Note:</b> There is no causality between the <code>uDPSend</code> block and the <code>uDPReceive</code> block. Therefore the execution order of the blocks is not determined. Additionally, the <code>uDPReceive</code> block starts an own receiving thread, so that the time the data was received is not equal to the time the external function within the <code>uDPReceive</code> block was called. This indeterminism may also show up in the plots.
</p>
</html>"));
end TestSerialPackager_UDP;
