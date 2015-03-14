within Modelica_DeviceDrivers.Blocks.Examples;
model TestSerialPackager_UDPMinimalForOMCTest
  "Example for combining UDP and SerialPackager blocks"
  extends Modelica.Icons.Example;
  Modelica_DeviceDrivers.Blocks.Packaging.SerialPackager.Packager packager(
      useBackwardPropagatedBufferSize=false)                               annotation(Placement(transformation(extent = {{-40, 62}, {-20, 82}})));
  Modelica_DeviceDrivers.Blocks.Packaging.SerialPackager.AddReal addReal(n = 3, nu = 1) annotation(Placement(transformation(extent = {{-40, 34}, {-20, 54}})));
  Modelica.Blocks.Sources.RealExpression realExpression[3](y = sin(time) * {1, 2, 3}) annotation(Placement(transformation(extent = {{-80, 34}, {-60, 54}})));
  Modelica_DeviceDrivers.Blocks.Communication.UDPSend uDPSend(port_send = 10002) annotation(Placement(transformation(extent = {{-10, -10}, {10, 10}}, rotation = 270, origin = {-30, 12})));
  // Modelica_DeviceDrivers.Blocks.Communication.UDPReceive uDPReceive(port_recv = 10002) annotation(Placement(transformation(extent = {{-10, -10}, {10, 10}}, rotation = 270, origin = {40, 50})));
  // Modelica_DeviceDrivers.Blocks.Packaging.SerialPackager.GetReal getReal(n = 3) annotation(Placement(transformation(extent = {{30, 10}, {50, 30}})));
equation
  connect(realExpression.y, addReal.u) annotation(Line(points = {{-59, 44}, {-42, 44}}, color = {0, 0, 127}));
  connect(packager.pkgOut, addReal.pkgIn) annotation(Line(points = {{-30, 61.2}, {-30, 54.8}}));
  //connect(uDPReceive.pkgOut, getReal.pkgIn) annotation(Line(points = {{40, 39.2}, {40, 30.8}}));
  connect(addReal.pkgOut[1], uDPSend.pkgIn) annotation(Line(points = {{-30, 33.2}, {-30, 22.8}}, color = {0, 0, 0}));
  annotation(experiment(StopTime = 5.0), Documentation(info = "<html>
 <p>
 The <code>uDPSend</code> block sends to the local port 10002. The <code>uDPReceive</code> block starts a background process that listens at port 10002. Consequently, the <code>uDPReceive</code> block receives what the <code>uDPSend</code> block sends.
 </p>
 <p>
 <b>Note:</b> There is no causality between the <code>uDPSend</code> block and the <code>uDPReceive</code> block. Therefore the execution order of the blocks is not determined. Additionally, the <code>uDPReceive</code> block starts an own receiving thread, so that the time the data was received is not equal to the time the external function within the <code>uDPReceive</code> block was called. This indeterminism may also show up in the plots.
 </p>
 </html>"));
end TestSerialPackager_UDPMinimalForOMCTest;
