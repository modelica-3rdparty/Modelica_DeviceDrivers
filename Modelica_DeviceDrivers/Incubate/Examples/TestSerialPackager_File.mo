within Modelica_DeviceDrivers.Incubate.Examples;
model TestSerialPackager_File "Example for file source and file sink"
  extends Modelica.Icons.Example;
  Modelica_DeviceDrivers.Incubate.Blocks.Communication.TextFileSource fileSource(
    enableExternalTrigger=true,
    autoBufferSize=false,
    userBufferSize=512,
    showReceivedBytesPort=true,
    fileName= Modelica.Utilities.Files.loadResource("modelica://Modelica_DeviceDrivers/Resources/Licenses/LICENSE_Modelica_DeviceDrivers.txt"))
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={-50,30})));
  Modelica.Blocks.Sources.SampleTrigger sampleTrigger(period=0.02)
    annotation (Placement(transformation(extent={{-100,20},{-80,40}})));
  Modelica_DeviceDrivers.Incubate.Blocks.Communication.TextFileSink textFileSink(
    enableExternalTrigger=true,
    printToTerminal=true,
    autoBufferSize=false,
    userBufferSize=512) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={-50,-52})));
equation
  connect(sampleTrigger.y, fileSource.trigger)
    annotation (Line(points={{-79,30},{-62,30}}, color={255,0,255}));
  connect(fileSource.pkgOut, textFileSink.pkgIn)
    annotation (Line(points={{-50,19.2},{-50,-41.2}}, color={0,0,0}));
  connect(sampleTrigger.y, textFileSink.trigger) annotation (Line(points={{-79,
          30},{-70,30},{-70,-52},{-62,-52}}, color={255,0,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end TestSerialPackager_File;
