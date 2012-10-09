within Modelica_DeviceDrivers.Blocks.Examples;
model TestSerialPackager_UDP
  "Example for combining UDP and SerialPackager blocks"
extends Modelica.Icons.Example;
  Modelica_DeviceDrivers.Blocks.Packaging.SerialPackager.Packager
                     packager
    annotation (Placement(transformation(extent={{-40,40},{-20,60}})));
  Modelica_DeviceDrivers.Blocks.Packaging.SerialPackager.AddReal
                    addReal(n=3, nu=1)
    annotation (Placement(transformation(extent={{-40,12},{-20,32}})));
  Modelica.Blocks.Sources.RealExpression realExpression[3](y=sin(time)*{1,2,3})
    annotation (Placement(transformation(extent={{-80,12},{-60,32}})));
  Modelica_DeviceDrivers.Blocks.Communication.UDPSend
                                  uDPSend(port_send=10002)
                                                 annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={-30,-50})));
  Modelica_DeviceDrivers.Blocks.Packaging.SerialPackager.AddInteger
                       addInteger(nu=1)
    annotation (Placement(transformation(extent={{-40,-20},{-20,0}})));
  Modelica.Blocks.Sources.IntegerExpression integerExpression(y=integer(10*sin(
        time)))
    annotation (Placement(transformation(extent={{-80,-20},{-60,0}})));
  Modelica_DeviceDrivers.Blocks.Communication.UDPReceive
                                 uDPReceive(port_recv=10002)
                                      annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={40,50})));
  Modelica_DeviceDrivers.Blocks.Packaging.SerialPackager.GetReal
                    getReal(n=3, nu=1)
    annotation (Placement(transformation(extent={{30,0},{50,20}})));
  Modelica_DeviceDrivers.Blocks.Packaging.SerialPackager.GetInteger
                       getInteger
    annotation (Placement(transformation(extent={{30,-40},{50,-20}})));
equation
  connect(integerExpression.y, addInteger.u[1]) annotation (Line(
      points={{-59,-10},{-42,-10}},
      color={255,127,0},
      pattern=LinePattern.None,
      smooth=Smooth.None));
  connect(realExpression.y, addReal.u) annotation (Line(
      points={{-59,22},{-42,22}},
      color={0,0,127},
      pattern=LinePattern.None,
      smooth=Smooth.None));
  connect(packager.pkgOut, addReal.pkgIn) annotation (Line(
      points={{-30,39.2},{-30,32.8}},
      color={0,0,0},
      pattern=LinePattern.None,
      smooth=Smooth.None));
  connect(addReal.pkgOut[1], addInteger.pkgIn) annotation (Line(
      points={{-30,11.2},{-30,0.8}},
      color={0,0,0},
      pattern=LinePattern.None,
      smooth=Smooth.None));
  connect(addInteger.pkgOut[1], uDPSend.pkgIn) annotation (Line(
      points={{-30,-20.8},{-30,-39.2}},
      color={0,0,0},
      pattern=LinePattern.None,
      smooth=Smooth.None));
  connect(uDPReceive.pkgOut, getReal.pkgIn) annotation (Line(
      points={{40,39.2},{40,20.8}},
      color={0,0,0},
      pattern=LinePattern.None,
      smooth=Smooth.None));
  connect(getReal.pkgOut[1], getInteger.pkgIn) annotation (Line(
      points={{40,-0.8},{40,-19.2}},
      color={0,0,0},
      pattern=LinePattern.None,
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,
            -100},{100,100}}), graphics), experiment(StopTime=5.0),
    Documentation(info="<html>
<p>
The <code>uDPSend</code> block sends to the local port 10002. The <code>uDPReceive</code> block starts a background process that listens at port 10002. Consequently, the <code>uDPReceive</code> block receives what the <code>uDPSend</code> block sends.
</p>
<p>
<b>Note:</b> There is no causality between the <code>uDPSend</code> block and the <code>uDPReceive</code> block. Therefore the execution order of the blocks is not determined. Additionally, the <code>uDPReceive</code> block starts an own receiving thread, so that the time the data was received is not equal to the time the external function within the <code>uDPReceive</code> block was called. This indeterminism may also show up in the plots.
</p>
</html>"));
end TestSerialPackager_UDP;
