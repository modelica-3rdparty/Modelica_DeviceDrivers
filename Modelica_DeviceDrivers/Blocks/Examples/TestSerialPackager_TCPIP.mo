within Modelica_DeviceDrivers.Blocks.Examples;
model TestSerialPackager_TCPIP
  "Example for combining TCP/IP and SerialPackager blocks"
  extends Modelica.Icons.Example;
  Modelica_DeviceDrivers.Blocks.Packaging.SerialPackager.Packager packager(useBackwardPropagatedBufferSize=false, userBufferSize=36) annotation(Placement(transformation(extent={{-40,62},{-20,82}})));
  Modelica_DeviceDrivers.Blocks.Packaging.SerialPackager.AddReal addReal(
    nu=1,
    n=3) annotation(Placement(transformation(extent={{-40,34},{-20,54}})));
  Modelica.Blocks.Sources.RealExpression realExpression[3](y=sin(time)*{1,2,3}) annotation(Placement(transformation(extent={{-80,34},{-60,54}})));
  Modelica_DeviceDrivers.Blocks.Communication.TCPIP_Client_IO tcpipClient(port=27015, outputBufferSize=36, inputBufferSize=36) annotation(Placement(transformation(
 origin={5,5},
 extent={{-10,-10},{10,10}},
 rotation=90)));
  Modelica_DeviceDrivers.Blocks.Packaging.SerialPackager.AddInteger addInteger(nu=1) annotation(Placement(transformation(extent={{-40,-26},{-20,-6}})));
  Modelica.Blocks.Sources.IntegerExpression integerExpression(y=integer(10*sin(
          time))) annotation(Placement(transformation(extent={{-80,-26},{-60,-6}})));
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
    connect(realExpression1.y, addFloat.u) annotation (Line(
        points={{-57,12},{-42,12}},
        color={0,0,127}));
    connect(addReal.pkgOut[1], addFloat.pkgIn) annotation (Line(
        points={{-30,33.2},{-30,22.8}}));
    connect(addFloat.pkgOut[1], addInteger.pkgIn) annotation (Line(
        points={{-30,1.2},{-30,-5.2}}));
    connect(getReal.pkgOut[1], getFloat.pkgIn) annotation (Line(
        points={{40,9.2},{40,2.8}}));
    connect(getInteger.pkgIn, getFloat.pkgOut[1]) annotation (Line(
        points={{40,-27.2},{40,-18.8}}));
 connect(tcpipClient.pkgOut,getReal.pkgIn) annotation(Line(
  points={{5,15.8},{5,15.8},{5,35.7},{40,35.7},{40,30.8}}));
 connect(addInteger.pkgOut[1],tcpipClient.pkgIn) annotation(Line(
  points={{-30,-26.8},{-30,-31.7},{5,-31.7},{5,-5.8},{5,-5.8}}));
  annotation (
    Documentation(info="<html>
<p>
The <code>tcpipClient</code> block tries to connect to the server on local TCP port 27015. Once the client connects, the client sends data to the server and receives any data send back from the server. The client then closes the socket and exits.
</p>
<p>
There is <a href=\"modelica://Modelica_DeviceDrivers/Resources/thirdParty/Microsoft/test_TCPIPSocketServerEcho.cpp\">test server</a> provided that echos the received data back to the client.
</p>
</html>"),
    experiment(
      StopTime=5,
      StartTime=0));
end TestSerialPackager_TCPIP;
