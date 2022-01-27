within Modelica_DeviceDrivers.Blocks.Examples;
model TestInputJoystick "Example for a joystick/gamepad"
extends Modelica.Icons.Example;
  InputDevices.JoystickInput joystickInput
    annotation (Placement(transformation(extent={{-40,0},{-20,20}})));
  OperatingSystem.RealtimeSynchronize realtimeSynchronize
    annotation (Placement(transformation(extent={{-80,0},{-60,20}})));
  annotation (experiment(StopTime=5.0), Documentation(info="<html>
<p>
Basic example of using inputs from a joystick/gamepad device.
</p>
</html>"));
end TestInputJoystick;
