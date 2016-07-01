within Modelica_DeviceDrivers.Blocks.Examples;
model TestSerialPackager_LCM
  "Example for combining LCM and SerialPackager blocks with deactivated autoBufferSize / useBackwardPropagatedBufferSize"
  extends Modelica.Icons.Example;
  Modelica_DeviceDrivers.Blocks.Packaging.SerialPackager.Packager packager(useBackwardPropagatedBufferSize=false, userBufferSize=36) annotation(Placement(transformation(extent={{-40,28},
            {-20,48}})));
  Modelica_DeviceDrivers.Blocks.Packaging.SerialPackager.AddReal addReal(
    nu=1,
    n=3) annotation(Placement(transformation(extent={{-40,0},{-20,20}})));
  Modelica.Blocks.Sources.RealExpression realExpression[3](y=sin(time)*{1,2,3}) annotation(Placement(transformation(extent={{-80,0},
            {-60,20}})));
  Modelica_DeviceDrivers.Blocks.Communication.LCMSend lcmSend(
    autoBufferSize=false,
    userBufferSize=36,
    port=10002,
    channel_send="lcm_example") annotation(Placement(transformation(
    origin={-30,-78},
    extent={{-10,-10},{10,10}},
    rotation=270)));
  Modelica_DeviceDrivers.Blocks.Packaging.SerialPackager.AddInteger addInteger(nu=1) annotation(Placement(transformation(extent={{-40,-60},
            {-20,-40}})));
  Modelica.Blocks.Sources.IntegerExpression integerExpression(y=integer(10*sin(
          time))) annotation(Placement(transformation(extent={{-80,-60},{-60,
            -40}})));
  Modelica_DeviceDrivers.Blocks.Communication.LCMReceive lcmReceive(
    autoBufferSize=false,
    userBufferSize=36,
    port=10002,
    channel_recv="lcm_example") annotation(Placement(transformation(
    origin={40,16},
    extent={{-10,-10},{10,10}},
    rotation=270)));
  Modelica_DeviceDrivers.Blocks.Packaging.SerialPackager.GetReal getReal(
    nu=1,
    n=3) annotation(Placement(transformation(extent={{30,-24},{50,-4}})));
  Modelica_DeviceDrivers.Blocks.Packaging.SerialPackager.GetInteger getInteger annotation(Placement(transformation(extent={{30,-82},
            {50,-62}})));
  Packaging.SerialPackager.AddFloat addFloat(
    nu=1,
    n=2) annotation(Placement(transformation(extent={{-40,-32},{-20,-12}})));
  Packaging.SerialPackager.GetFloat getFloat(
    nu=1,
    n=2) annotation(Placement(transformation(extent={{30,-52},{50,-32}})));
  Modelica.Blocks.Sources.RealExpression realExpression1[2](y=sin(time)*{1,2}) annotation(Placement(transformation(extent={{-78,-32},
            {-58,-12}})));
equation
    connect(integerExpression.y, addInteger.u[1]) annotation (Line(
        points={{-59,-50},{-42,-50}},
        color={255,127,0}));
    connect(realExpression.y, addReal.u) annotation (Line(
        points={{-59,10},{-42,10}},
        color={0,0,127}));
    connect(packager.pkgOut, addReal.pkgIn) annotation (Line(
        points={{-30,27.2},{-30,20.8}}));
    connect(lcmReceive.pkgOut, getReal.pkgIn) annotation (Line(
        points={{40,5.2},{40,-3.2}}));
    connect(realExpression1.y, addFloat.u) annotation (Line(
        points={{-57,-22},{-42,-22}},
        color={0,0,127}));
    connect(addReal.pkgOut[1], addFloat.pkgIn) annotation (Line(
        points={{-30,-0.8},{-30,-11.2}}));
    connect(addFloat.pkgOut[1], addInteger.pkgIn) annotation (Line(
        points={{-30,-32.8},{-30,-39.2}}));
    connect(lcmSend.pkgIn, addInteger.pkgOut[1]) annotation (Line(
        points={{-30,-67.2},{-30,-60.8}}));
    connect(getReal.pkgOut[1], getFloat.pkgIn) annotation (Line(
        points={{40,-24.8},{40,-31.2}}));
    connect(getInteger.pkgIn, getFloat.pkgOut[1]) annotation (Line(
        points={{40,-61.2},{40,-52.8}}));
  annotation (
    Documentation(info="<html>
<p>
The <code>lcmSend</code> block sends to the local port 10002. The <code>lcmReceive</code> block starts a background process that listens at port 10002. Consequently, the <code>lcmReceive</code> block receives what the <code>lcmSend</code> block sends.
</p>
<p>
<b>Note:</b> There is no causality between the <code>lcmSend</code> block and the <code>lcmReceive</code> block. Therefore the execution order of the blocks is not determined. Additionally, the <code>lcmReceive</code> block starts an own receiving thread, so that the time the data was received is not equal to the time the external function within the <code>lcmReceive</code> block was called. This indeterminism may also show up in the plots.
</p>
<h4><font color=\"#008000\">Remark regarding Linux</font></h4>
<p>
LCM requires a valid multicast route. If this is a Linux computer and it is
simply not connected to a network, the following commands are usually
sufficient as a temporary solution:
</p>
<pre>
sudo ifconfig lo multicast
sudo route add -net 224.0.0.0 netmask 240.0.0.0 dev lo
</pre>
</html>"),
    experiment(
      StopTime=5,
      StartTime=0),
    Diagram(graphics={        Text(
          extent={{-94,88},{96,60}},
          lineColor={0,0,255},
          textString="Please have a look at the documentation
before trying this example.")}));
end TestSerialPackager_LCM;
