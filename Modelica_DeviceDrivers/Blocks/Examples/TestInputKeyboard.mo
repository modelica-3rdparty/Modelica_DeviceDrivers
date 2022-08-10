within Modelica_DeviceDrivers.Blocks.Examples;
model TestInputKeyboard "Example for keyboard input"
extends Modelica.Icons.Example;
  OperatingSystem.RealtimeSynchronize realtimeSynchronize
    annotation (Placement(transformation(extent={{-80,0},{-60,20}})));
  InputDevices.KeyboardInput keyboardInput
    annotation (Placement(transformation(extent={{-40,0},{-20,20}})));
  annotation (experiment(StopTime=5.0), Documentation(info="<html>
<p>
Basic example of using a keyboard as input device.
</p>
</html>"));
end TestInputKeyboard;
