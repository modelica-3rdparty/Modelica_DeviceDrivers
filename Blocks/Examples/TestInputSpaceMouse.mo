within Modelica_DeviceDrivers.Blocks.Examples;
block TestInputSpaceMouse
extends Modelica.Icons.Example;
  InputDevices.SpaceMouseInput spaceMouseInput
    annotation (Placement(transformation(extent={{-20,40},{0,60}})));
  OperatingSystem.SynchronizeRealtime synchronizeRealtime
    annotation (Placement(transformation(extent={{-80,20},{-60,40}})));
end TestInputSpaceMouse;
