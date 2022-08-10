within Modelica_DeviceDrivers.Blocks.Examples;
model TestInputKeyboardKey
  "Example for keyboard input using the KeyboardKeyInput block"
extends Modelica.Icons.Example;
  OperatingSystem.RealtimeSynchronize realtimeSynchronize
    annotation (Placement(transformation(extent={{-80,0},{-60,20}})));
  InputDevices.KeyboardKeyInput keyboardKeyInput(keyCode="Space")
    annotation (Placement(transformation(extent={{-40,0},{-20,20}})));
  annotation (experiment(StopTime=5.0), Documentation(info="<html>
<p>Basic example of using a keyboard as input device. For this example the parameter <code>keyCode</code> is set to the &quot;space&quot; key. Therefore, pressing <i>space</i> while the simulation is running will turn the output of the block to <b>true</b>, otherwise it is <b>false</b>
</p>
</html>"));
end TestInputKeyboardKey;
