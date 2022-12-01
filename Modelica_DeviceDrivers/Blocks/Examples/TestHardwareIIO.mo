within Modelica_DeviceDrivers.Blocks.Examples;
model TestHardwareIIO "Example to access the Inertial Measurement Unit of a Pinephone via InternetIO"
  import Modelica_DeviceDrivers;
  extends Modelica.Icons.Example;

  Modelica_DeviceDrivers.Blocks.HardwareIO.IIO.IIOConfig iio(deviceName="mobian.local")
    annotation (Placement(transformation(extent={{-80,60},{-60,80}})));
  Modelica_DeviceDrivers.Blocks.HardwareIO.IIO.PhysicalDataRead dataRead_x(
    sampleTime=0.05,
    iio=iio.dh,
    devicename="mpu6050",
    channelname="accel_x") annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));
  Modelica_DeviceDrivers.Blocks.OperatingSystem.RealtimeSynchronize
    realtimeSynchronize(
    enable=true,
    sampled=true,
    sampleTime=0.05)
    annotation (Placement(transformation(extent={{60,60},{80,80}})));
  Modelica_DeviceDrivers.Blocks.HardwareIO.IIO.PhysicalDataRead dataRead_y(
    sampleTime=0.05,
    iio=iio.dh,
    devicename="mpu6050",
    channelname="accel_y") annotation (Placement(transformation(extent={{-80,-40},{-60,-20}})));
  Modelica_DeviceDrivers.Blocks.HardwareIO.IIO.PhysicalDataRead dataRead_z(
    sampleTime=0.05,
    iio=iio.dh,
    devicename="mpu6050",
    channelname="accel_z") annotation (Placement(transformation(extent={{-80,-70},{-60,-50}})));
  Modelica.Blocks.Routing.Multiplex3 a annotation (Placement(transformation(extent={{-40,-40},{-20,-20}})));

  BullsEyeLevel bullsEyeLevel annotation (Placement(transformation(extent={{10,-70},{90,10}})));

  model BullsEyeLevel
    extends Modelica.Blocks.Interfaces.MIMO(nin=3,nout=2);

    parameter Modelica.Units.SI.Length d = 0.02 "Diameter of the virtual detection sphere";

    Modelica.Units.SI.Length r[3] "Position of the ball";
    Modelica.Units.SI.Velocity v[3] "Velocity of the ball";
    Modelica.Units.SI.Acceleration a[3] "Acceleration of the ball";

    Modelica.Units.SI.Angle theta "Polar angle from the origin to the ball";
    Modelica.Units.SI.Angle psi "Azimuth angle from the origin to the ball";

    Modelica.Mechanics.MultiBody.Types.Axis e_r "Normalized vector from the origin to the ball";
    Modelica.Mechanics.MultiBody.Types.Axis e_theta "Normalized vector in azimuth direction on the sphere";
    Modelica.Mechanics.MultiBody.Types.Axis e_psi "Normalized vector in altitude direction on the sphere";

    Real x2D[2] "Coordinates of the ball center in 2D representation";

  equation
    e_r[1] = sin(theta)*cos(psi);
    e_r[2] = sin(theta)*sin(psi);
    e_r[3] = cos(theta);

    e_theta[1] = cos(theta)*cos(psi);
    e_theta[2] = cos(theta)*sin(psi);
    e_theta[3] = -sin(theta);

    e_psi = cross(e_r,e_theta);

    r = d/2*e_r;
    der(r) = v;
    a = u;

    der(theta) = a*e_theta;
    der(psi) = a*e_psi/max(Modelica.Constants.eps,d/2*sin(theta));

    y = {theta,psi};

    x2D[1] = -80*sin(theta)*sin(psi);
    x2D[2] = 80*sin(theta)*cos(psi);

    annotation (Icon(graphics={
          Ellipse(extent={{-80,80},{80,-80}}, lineColor={0,0,0}),
          Ellipse(extent={{-40,40},{40,-40}}, lineColor={0,0,0}),
          Line(
            points={{0,-90},{0,90}},
            color={0,0,0},
            pattern=LinePattern.None),
          Line(points={{0,-90},{0,90}}, color={0,0,0}),
          Line(points={{-90,0},{90,0}}, color={0,0,0}),
          Ellipse(
            extent=DynamicSelect({{-10,10},{10,-10}},{{-10,10}+x2D,{10,-10}+x2D}),
            pattern=LinePattern.None,
            fillColor={0,0,0},
            fillPattern=FillPattern.Solid)}), Documentation(info="<html>
<p><span style=\"font-size: 9pt;\">This model implements a virtual ball hinged with a fixed radius to a central fixation resctricting its path to a sphere. The input accelerations act on that ball. The animation is a top view of the sphere with the current position of the ball.</span></p>
</html>"));
  end BullsEyeLevel;
equation
  connect(dataRead_x.y, a.u1[1]) annotation (Line(points={{-59,0},{-50,0},{-50,-23},{-42,-23}}, color={0,0,127}));
  connect(dataRead_y.y, a.u2[1]) annotation (Line(points={{-59,-30},{-42,-30}}, color={0,0,127}));
  connect(dataRead_z.y, a.u3[1]) annotation (Line(points={{-59,-60},{-50,-60},{-50,-37},{-42,-37}}, color={0,0,127}));
  connect(a.y, bullsEyeLevel.u) annotation (Line(points={{-19,-30},{2,-30}}, color={0,0,127}));
  annotation (Documentation(info="<html>
<p>This example was tested with a Mobian installation on a Pinephone. The package <span style=\"font-family: Courier New;\">iiod</span> has to be installed on the phone. It works out-of-the-box without further configuration.</p>
<p>Any other linux device supporting IIO can be used. Only the IIO deamon has to be installed and configured.</p>
</html>"));
end TestHardwareIIO;
