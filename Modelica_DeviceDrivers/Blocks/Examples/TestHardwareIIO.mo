within Modelica_DeviceDrivers.Blocks.Examples;
model TestHardwareIIO "Example to access the Inertial Measurement Unit of a Pinephone via InternetIO"
  import Modelica_DeviceDrivers;
extends Modelica.Icons.Example;

  Modelica_DeviceDrivers.Blocks.HardwareIO.IIO.IIOConfig iio(deviceName="mobian.local")
    annotation (Placement(transformation(extent={{-80,60},{-60,80}})));
  Modelica_DeviceDrivers.Blocks.HardwareIO.IIO.PhysicalDataRead dataRead_x(
    sampleTime=0.1,
    iio=iio.dh,
    devicename="mpu6050",
    channelname="accel_x") annotation (Placement(transformation(extent={{-80,20},{-60,40}})));
  Modelica_DeviceDrivers.Blocks.OperatingSystem.RealtimeSynchronize
    realtimeSynchronize
    annotation (Placement(transformation(extent={{60,60},{80,80}})));
  Modelica_DeviceDrivers.Blocks.HardwareIO.IIO.PhysicalDataRead dataRead_y(
    sampleTime=0.1,
    iio=iio.dh,
    devicename="mpu6050",
    channelname="accel_y") annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));
  Modelica_DeviceDrivers.Blocks.HardwareIO.IIO.PhysicalDataRead dataRead_z(
    sampleTime=0.1,
    iio=iio.dh,
    devicename="mpu6050",
    channelname="accel_z") annotation (Placement(transformation(extent={{-80,-40},{-60,-20}})));
  Modelica.Blocks.Routing.Multiplex3 a annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));
  Modelica.Blocks.Math.Feedback feedback[3] annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Sources.RealExpression realExpression[3](y={0.11838963325622613,
        0.17931387736615592,9.054748576489855}) annotation (Placement(transformation(extent={{-40,-60},{-20,-40}})));
  Modelica.Blocks.Continuous.Integrator v[3] annotation (Placement(transformation(extent={{20,-10},{40,10}})));
  Modelica.Blocks.Continuous.Integrator s[3] annotation (Placement(transformation(extent={{60,-10},{80,10}})));
  Modelica.Mechanics.MultiBody.Visualizers.FixedShape fixedShape(
    shapeType="sphere",
    r_shape=a.y,
    length=0.1,
    width=0.1,
    height=0.1) annotation (Placement(transformation(extent={{20,60},{40,80}})));
  inner Modelica.Mechanics.MultiBody.World world annotation (Placement(transformation(extent={{-20,60},{0,80}})));
equation
  connect(dataRead_x.y, a.u1[1]) annotation (Line(points={{-59,30},{-50,30},{-50,7},{-42,7}}, color={0,0,127}));
  connect(dataRead_y.y, a.u2[1]) annotation (Line(points={{-59,0},{-42,0}}, color={0,0,127}));
  connect(dataRead_z.y, a.u3[1]) annotation (Line(points={{-59,-30},{-50,-30},{-50,-7},{-42,-7}}, color={0,0,127}));
  connect(a.y, feedback.u1) annotation (Line(points={{-19,0},{-8,0}}, color={0,0,127}));
  connect(realExpression.y, feedback.u2) annotation (Line(points={{-19,-50},{0,-50},{0,-8}}, color={0,0,127}));
  connect(feedback.y, v.u) annotation (Line(points={{9,0},{18,0}}, color={0,0,127}));
  connect(v.y, s.u) annotation (Line(points={{41,0},{58,0}}, color={0,0,127}));
  connect(world.frame_b, fixedShape.frame_a)
    annotation (Line(
      points={{0,70},{20,70}},
      color={95,95,95},
      thickness=0.5));
  annotation (
      experiment(StopTime=5.0),
    Documentation(info="<html>
<p>This example was tested with a Mobian installation on a Pinephone. The package <span style=\"font-family: Courier New;\">iiod</span> has to be installed on the phone. It works out-of-the-box without further configuration.</p>
<p>Any other linux device supporting IIO can be used. Only the IIO deamon has to be installed and configured.</p>
</html>"));
end TestHardwareIIO;
