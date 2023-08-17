within Modelica_DeviceDrivers.Blocks.Examples;
model TestSerialPackager_TCPIPServerMultipleClients
  "Example for configuring a TCP/IP server so that multiple clients can connect"
  extends Modelica.Icons.Example;
  inner Modelica_DeviceDrivers.Blocks.Communication.TCPIPServerConfig
    tcpipserverconfig(
    port=10002,
    maxClients=2,
    useNonblockingMode=true)
    annotation (Placement(transformation(extent={{-80,-60},{-60,-40}})));
  Modelica_DeviceDrivers.Blocks.Communication.TCPIPServerReceive tCPIPReceive[2](
    clientIndex={1,2},
    each blockUntilConnected=false,
    each showAdvancedOutputs=true) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={-30,40})));
  Modelica_DeviceDrivers.Blocks.Packaging.SerialPackager.GetInteger getInteger[2](each n=3)
    annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));
  OperatingSystem.RealtimeSynchronize realtimeSynchronize
    annotation (Placement(transformation(extent={{-40,-60},{-20,-40}})));
  Packaging.SerialPackager.Packager packager[2](
    each useBackwardPropagatedBufferSize=false,
    each userBufferSize=12)
    annotation (Placement(transformation(extent={{20,30},{40,50}})));
  Packaging.SerialPackager.AddInteger addInteger[2](each n=3, each nu=1)
    annotation (Placement(transformation(extent={{20,-10},{40,10}})));
  Communication.TCPIPServerSend tCPIPSend[2](
    each enableExternalTrigger=true,
    clientIndex={1,2},
    each blockUntilConnected=false,
    each autoBufferSize=true,
    each userBufferSize=12) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={30,-40})));
  Process process[2]
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
    annotation (Line(points={{30,29.2},{30,10.8}},color={0,0,0}));
  connect(tCPIPReceive.recvTrigger, tCPIPSend.trigger) annotation (Line(points={{-36,29},
          {-36,20},{-40,20},{-40,-20},{0,-20},{0,-40},{18,-40}},
                                                          color={255,0,255}));
  connect(addInteger[1:2].pkgOut[1], tCPIPSend[1:2].pkgIn)
    annotation (Line(points={{30,-10.8},{30,-29.2}}, color={0,0,0}));
  connect(getInteger.y, process.u)
    annotation (Line(points={{-19,0},{-12,0}}, color={255,127,0}));
  connect(process.y, addInteger.u)
    annotation (Line(points={{11,0},{18,0}}, color={255,127,0}));
  connect(process.trigger, tCPIPReceive.recvTrigger) annotation (Line(points={{0,-12},
          {0,-20},{-40,-20},{-40,20},{-36,20},{-36,29}},        color={255,0,
          255}));
  annotation (
    Documentation(info="<html>
<p>
This example uses array components of TCP/IP server receive and send blocks as well as related SerialPackager blocks.
It needs suitable connecting TCP/IP clients for giving meaningful results.
</p>
<p>
<strong>Caveat:</strong> Notice that it was necessary to modify the Modelica code that resulted from graphical
editing in Dymola, by manually adapting the underlying Modelica code, namely:
</p>
<code>
AddInteger addInteger[2](each n=3, each nu=1)
<br>
connect(addInteger[1:2].pkgOut[1], tCPIPSend[1:2].pkgIn)
</code>
</html>"),
    experiment(StopTime=10),
    Diagram(graphics={
        Text(
          extent={{-100,-70},{98,-90}},
          textColor={28,108,200},
          textString="Example uses array components.
Notice that it was necessary to modify the Modelica code that resulted from graphical editing, by textually adapting statements, namely:
AddInteger addInteger[2](each n=3, each nu=1)
connect(addInteger[1:2].pkgOut[1], tCPIPSend[1:2].pkgIn)"),
        Text(
          extent={{-80,100},{80,80}},
          textColor={238,46,47},
          textString="Needs connecting clients to give meaningful results")}));
end TestSerialPackager_TCPIPServerMultipleClients;
