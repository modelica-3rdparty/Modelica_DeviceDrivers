within Modelica_DeviceDrivers.Blocks.Examples;
model TestSerialPackager_TCPIPServer
  "Example for combining TCP/IP server and SerialPackager blocks. Needs a connecting client."
  extends Modelica.Icons.Example;
  inner Modelica_DeviceDrivers.Blocks.Communication.TCPIPServerConfig
    tcpipserverconfig(
    port=10002,
    maxClients=1,
    useNonblockingMode=true)
    annotation (Placement(transformation(extent={{-80,-80},{-60,-60}})));
  Modelica_DeviceDrivers.Blocks.Communication.TCPIPServerReceive tCPIPReceive(
    clientIndex=1,
    blockUntilConnected=false,
                   showAdvancedOutputs=true)
                                annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={-30,40})));
  Modelica_DeviceDrivers.Blocks.Packaging.SerialPackager.GetInteger getInteger(n=3)
    annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));
  Modelica_DeviceDrivers.Blocks.Packaging.SerialPackager.Packager packager(
      useBackwardPropagatedBufferSize=false, userBufferSize=12)
    annotation (Placement(transformation(extent={{20,30},{40,50}})));
  Modelica_DeviceDrivers.Blocks.Packaging.SerialPackager.AddInteger addInteger(n=3, nu=1)
    annotation (Placement(transformation(extent={{20,-10},{40,10}})));
  Modelica_DeviceDrivers.Blocks.Communication.TCPIPServerSend tCPIPSend(
    enableExternalTrigger=true,
    blockUntilConnected=false,
    autoBufferSize=true,
    userBufferSize=12) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={30,-40})));
  OperatingSystem.RealtimeSynchronize realtimeSynchronize
    annotation (Placement(transformation(extent={{-40,-80},{-20,-60}})));
  Process process
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
protected
  block Process
    extends Modelica.Blocks.Icons.Block;
    Modelica.Blocks.Interfaces.BooleanInput trigger annotation (Placement(
        transformation(
        extent={{-20,-20},{20,20}},
        rotation=90,
        origin={0,-120})));
    Modelica.Blocks.Interfaces.IntegerInput u[3]
      annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
    Modelica.Blocks.Interfaces.IntegerOutput y[3]
      annotation (Placement(transformation(extent={{100,-10},{120,10}})));
  equation
    when trigger then
      Modelica.Utilities.Streams.print("Process, t="+String(time));
      y = 2*u;
    end when;
    annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
          coordinateSystem(preserveAspectRatio=false)));
  end Process;
equation
  connect(tCPIPReceive.pkgOut, getInteger.pkgIn)
    annotation (Line(points={{-30,29.2},{-30,10.8}},color={0,0,0}));
  connect(packager.pkgOut, addInteger.pkgIn)
    annotation (Line(points={{30,29.2},{30,10.8}}, color={0,0,0}));
  connect(addInteger.pkgOut[1], tCPIPSend.pkgIn)
    annotation (Line(points={{30,-10.8},{30,-29.2}}, color={0,0,0}));
  connect(tCPIPSend.trigger, tCPIPReceive.recvTrigger) annotation (Line(points={{18,-40},
          {-42,-40},{-42,20},{-36,20},{-36,29}},           color={255,0,255}));
  connect(getInteger.y, process.u)
    annotation (Line(points={{-19,0},{-12,0}}, color={255,127,0}));
  connect(process.y, addInteger.u)
    annotation (Line(points={{11,0},{18,0}}, color={255,127,0}));
  connect(process.trigger, tCPIPReceive.recvTrigger) annotation (Line(points={{0,
          -12},{0,-40},{-42,-40},{-42,20},{-36,20},{-36,29}}, color={255,0,255}));
  annotation (
    Documentation(info="<html>
<p>
The <code>tcpipserverconfig</code> block is configured for listening at port 10002 and for using a non-blocking TCP/IP
socket.
</p>
<p>
For meaningful results a TCP/IP client needs to connect and send suitable data, otherwise no data is received. Such
a client is provided as C code test program 
(<a href=\"modelica://Modelica_DeviceDrivers/Resources/test/Communication/TCPIPClientAsRemoteStation.c\">Resources/test/Communication/TCPIPClientAsRemoteStation.c</a>).
</p>
</html>"),
    experiment(StopTime=10),
    Diagram(graphics={
        Text(
          extent={{-68,102},{66,84}},
          textColor={238,46,47},
          textString="Needs a connecting client to give meaningful results")}));
end TestSerialPackager_TCPIPServer;
