within Modelica_DeviceDrivers.Blocks.Examples;
model TestSerialPackager_UDPExternalTrigger
  "Example externally triggered UDP and SerialPackager blocks with deactivated autoBufferSize / useBackwardPropagatedBufferSize"
  extends Modelica.Icons.Example;
  Modelica_DeviceDrivers.Blocks.Packaging.SerialPackager.Packager packager(useBackwardPropagatedBufferSize=false, userBufferSize=36) annotation(Placement(transformation(extent={{-40,62},{-20,82}})));
  Modelica_DeviceDrivers.Blocks.Packaging.SerialPackager.AddReal addReal(
    nu=1,
    n=3) annotation(Placement(transformation(extent={{-40,34},{-20,54}})));
  Modelica.Blocks.Sources.RealExpression realExpression[3](y=sin(time)*{1,2,3}) annotation(Placement(transformation(extent={{-80,34},{-60,54}})));
  Modelica_DeviceDrivers.Blocks.Communication.UDPSend uDPSend(
    autoBufferSize=false,
    userBufferSize=36,
    port_send=10002,
    enableExternalTrigger=true)
                     annotation(Placement(transformation(
    origin={-30,-44},
    extent={{-10,10},{10,-10}},
    rotation=270)));
  Modelica_DeviceDrivers.Blocks.Packaging.SerialPackager.AddInteger addInteger(nu=1) annotation(Placement(transformation(extent={{-40,-26},{-20,-6}})));
  Modelica.Blocks.Sources.IntegerExpression integerExpression(y=integer(10*sin(
          time))) annotation(Placement(transformation(extent={{-80,-26},{-60,-6}})));
  Modelica_DeviceDrivers.Blocks.Communication.UDPReceive uDPReceive(
    autoBufferSize=false,
    userBufferSize=36,
    port_recv=10002,
    enableExternalTrigger=true)
                     annotation(Placement(transformation(
    origin={40,50},
    extent={{-10,-10},{10,10}},
    rotation=270)));
  Modelica_DeviceDrivers.Blocks.Packaging.SerialPackager.GetReal getReal(
    nu=1,
    n=3) annotation(Placement(transformation(extent={{30,10},{50,30}})));
  Modelica_DeviceDrivers.Blocks.Packaging.SerialPackager.GetInteger getInteger annotation(Placement(transformation(extent={{30,-48},{50,-28}})));
  Packaging.SerialPackager.AddFloat addFloat(
    nu=1,
    n=2) annotation(Placement(transformation(extent={{-40,2},{-20,22}})));
  Packaging.SerialPackager.GetFloat getFloat(
    nu=1,
    n=2) annotation(Placement(transformation(extent={{30,-18},{50,2}})));
  Modelica.Blocks.Sources.RealExpression realExpression1[2](y=sin(time)*{1,2}) annotation(Placement(transformation(extent={{-80,2},
            {-60,22}})));
  Modelica.Blocks.Sources.SampleTrigger sampleTrigger(period=0.1, startTime=0)
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=270,
        origin={0,70})));
equation
    connect(integerExpression.y, addInteger.u[1]) annotation (Line(
        points={{-59,-16},{-42,-16}},
        color={255,127,0}));
    connect(realExpression.y, addReal.u) annotation (Line(
        points={{-59,44},{-42,44}},
        color={0,0,127}));
    connect(packager.pkgOut, addReal.pkgIn) annotation (Line(
        points={{-30,61.2},{-30,54.8}}));
    connect(uDPReceive.pkgOut, getReal.pkgIn) annotation (Line(
        points={{40,39.2},{40,30.8}}));
    connect(realExpression1.y, addFloat.u) annotation (Line(
        points={{-59,12},{-42,12}},
        color={0,0,127}));
    connect(addReal.pkgOut[1], addFloat.pkgIn) annotation (Line(
        points={{-30,33.2},{-30,22.8}}));
    connect(addFloat.pkgOut[1], addInteger.pkgIn) annotation (Line(
        points={{-30,1.2},{-30,-5.2}}));
    connect(uDPSend.pkgIn, addInteger.pkgOut[1]) annotation (Line(
        points={{-30,-33.2},{-30,-26.8}}));
    connect(getReal.pkgOut[1], getFloat.pkgIn) annotation (Line(
        points={{40,9.2},{40,2.8}}));
    connect(getInteger.pkgIn, getFloat.pkgOut[1]) annotation (Line(
        points={{40,-27.2},{40,-18.8}}));
  connect(sampleTrigger.y, uDPSend.trigger) annotation (Line(
      points={{-1.9984e-15,59},{-1.9984e-15,-44},{-18,-44}},
      color={255,0,255}));
  connect(sampleTrigger.y, uDPReceive.trigger) annotation (Line(
      points={{0,59},{0,50},{28,50}},
      color={255,0,255}));
  annotation (
    Documentation(info="<html>
<p>
The <code>uDPSend</code> block sends to the local port 10002. The <code>uDPReceive</code> block starts a background process that listens at port 10002. Consequently, the <code>uDPReceive</code> block receives what the <code>uDPSend</code> block sends.
</p>
<p>
<b>Note:</b> There is no causality between the <code>uDPSend</code> block and the <code>uDPReceive</code> block. Therefore the execution order of the blocks is not determined. Additionally, the <code>uDPReceive</code> block starts an own receiving thread, so that the time the data was received is not equal to the time the external function within the <code>uDPReceive</code> block was called. This indeterminism may also show up in the plots.
</p>
<p>This example sends data to address 127.0.0.1, which is a special-purpose 
IPv4 address and is called the localhost or loopback address.
When you have to transfer data to another computer you have to use in uDPSend 
that computer's IP. You've also to set the port number of the remote computer you want to send to.</p>
<p>When you want to receive data from another computer, you have set in uDPReceive 
the actual port number of the local computer you a willing to receive data to.</p><p>
</html>"),
    experiment(
      StopTime=5,
      StartTime=0));
end TestSerialPackager_UDPExternalTrigger;
