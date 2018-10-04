within Modelica_DeviceDrivers.Blocks.Examples;
model TestSerialPackager_MQTT
  "Example for combining MQTT and SerialPackager blocks with deactivated autoBufferSize / useBackwardPropagatedBufferSize"
  extends Modelica.Icons.Example;
  Modelica_DeviceDrivers.Blocks.Packaging.SerialPackager.Packager packager(useBackwardPropagatedBufferSize=false, userBufferSize=36) annotation(Placement(transformation(extent={{-40,62},{-20,82}})));
  Modelica_DeviceDrivers.Blocks.Packaging.SerialPackager.AddReal addReal(
    nu=1,
    n=3) annotation(Placement(transformation(extent={{-40,34},{-20,54}})));
  Modelica.Blocks.Sources.RealExpression realExpression[3](y=sin(time)*{1,2,3}) annotation(Placement(transformation(extent={{-80,34},{-60,54}})));
  Modelica_DeviceDrivers.Blocks.Communication.MQTTSend mqttSend(
    autoBufferSize=false,
    userBufferSize=36,
    address="test.mosquitto.org",
    channel_send="mdd-example") annotation(Placement(transformation(
    origin={-30,-44},
    extent={{-10,-10},{10,10}},
    rotation=270)));
  Modelica_DeviceDrivers.Blocks.Packaging.SerialPackager.AddInteger addInteger(nu=1) annotation(Placement(transformation(extent={{-40,-26},{-20,-6}})));
  Modelica.Blocks.Sources.IntegerExpression integerExpression(
    y=integer(10*sin(time))) annotation(Placement(transformation(extent={{-80,-26},{-60,-6}})));
  Modelica_DeviceDrivers.Blocks.Communication.MQTTReceive mqttReceive(
    autoBufferSize=false,
    userBufferSize=36,
    address="test.mosquitto.org",
    channel_recv="mdd-example") annotation(Placement(transformation(
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
  Modelica.Blocks.Sources.RealExpression realExpression1[2](y=sin(time)*{1,2}) annotation(Placement(transformation(extent={{-78,2},{-58,22}})));
equation
    connect(integerExpression.y, addInteger.u[1]) annotation (Line(
        points={{-59,-16},{-42,-16}},
        color={255,127,0}));
    connect(realExpression.y, addReal.u) annotation (Line(
        points={{-59,44},{-42,44}},
        color={0,0,127}));
    connect(packager.pkgOut, addReal.pkgIn) annotation (Line(
        points={{-30,61.2},{-30,54.8}}));
    connect(mqttReceive.pkgOut, getReal.pkgIn) annotation (Line(
        points={{40,39.2},{40,30.8}}));
    connect(realExpression1.y, addFloat.u) annotation (Line(
        points={{-57,12},{-42,12}},
        color={0,0,127}));
    connect(addReal.pkgOut[1], addFloat.pkgIn) annotation (Line(
        points={{-30,33.2},{-30,22.8}}));
    connect(addFloat.pkgOut[1], addInteger.pkgIn) annotation (Line(
        points={{-30,1.2},{-30,-5.2}}));
    connect(mqttSend.pkgIn, addInteger.pkgOut[1]) annotation (Line(
        points={{-30,-33.2},{-30,-26.8}}));
    connect(getReal.pkgOut[1], getFloat.pkgIn) annotation (Line(
        points={{40,9.2},{40,2.8}}));
    connect(getInteger.pkgIn, getFloat.pkgOut[1]) annotation (Line(
        points={{40,-27.2},{40,-18.8}}));
  annotation (
    Documentation(info="<html>
<p>
The <code>mqttSend</code> block sends to the MQTT test broker <a href=\"http://test.mosquitto.org/\">test.mosquitto.org</a> at topic &quot;mdd-example&quot;. The <code>mqttReceive</code> block subscribes to the same broker at the same topic &quot;mdd-example&quot;. Consequently, the <code>mqttReceive</code> block receives what the <code>mqttSend</code> block sends.
</p>
<p>
<b>Note:</b> There is no causality between the <code>mqttSend</code> block and the <code>mqttReceive</code> block. Therefore the execution order of the blocks is not determined. Additionally, the <code>mqttReceive</code> block starts an own receiving thread, so that the time the data was received is not equal to the time the external function within the <code>mqttReceive</code> block was called. This indeterminism may also show up in the plots.
</p>
</html>"),
    experiment(
      StopTime=5,
      StartTime=0),
    Diagram(graphics={Bitmap(extent={{-11,-52.3},{25,-40}}, fileName="modelica://Modelica_DeviceDrivers/Resources/Images/pahologo.png")}));
end TestSerialPackager_MQTT;
