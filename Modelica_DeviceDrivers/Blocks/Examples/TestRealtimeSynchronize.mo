within Modelica_DeviceDrivers.Blocks.Examples;
model TestRealtimeSynchronize
  extends Modelica.Icons.Example;
  Modelica.Blocks.Sources.SampleTrigger sampleTrigger(period=0.1, startTime=0)
    annotation (Placement(transformation(extent={{-80,0},{-60,20}})));
  Utilities.TriggeredPrint t1
    annotation (Placement(transformation(extent={{-56,26},{-36,46}})));
  Modelica.Blocks.Logical.Pre pre1
    annotation (Placement(transformation(extent={{-40,0},{-20,20}})));
  Utilities.TriggeredPrint t2
    annotation (Placement(transformation(extent={{20,26},{40,46}})));
  OperatingSystem.RealtimeSynchronize realtimeSynchronize(
    scaling=1,                                            enable=true,
    sampled=true,
      enableExternalTrigger=true)
    annotation (Placement(transformation(extent={{-20,40},{0,60}})));
  OperatingSystem.ProcessPriority processPriority(priority="Normal")
    annotation (Placement(transformation(extent={{60,60},{80,80}})));
equation
  connect(sampleTrigger.y, t1.trigger)
    annotation (Line(points={{-59,10},{-46,10},{-46,30}}, color={255,0,255}));
  connect(pre1.u, sampleTrigger.y)
    annotation (Line(points={{-42,10},{-59,10}}, color={255,0,255}));
  connect(pre1.y, t2.trigger)
    annotation (Line(points={{-19,10},{30,10},{30,30}}, color={255,0,255}));
  connect(realtimeSynchronize.trigger, pre1.y)
    annotation (Line(points={{-10,38},{-10,10},{-19,10}}, color={255,0,255}));
  annotation (experiment(StopTime=5), Documentation(info="<html>
<p>
Example which uses an externally triggered real-time synchronization block. Whenever the real-time synchronization block is triggered it will block simulation progress until simulation time == real-time (wall clock time).
The example includes a block for modifying the process priority. A higher process priority can improve the real-time behavior.
</p>
</html>"));
end TestRealtimeSynchronize;
