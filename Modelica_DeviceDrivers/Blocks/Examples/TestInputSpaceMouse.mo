within Modelica_DeviceDrivers.Blocks.Examples;
model TestInputSpaceMouse "Example for a 3Dconnexion SpaceMouse"
extends Modelica.Icons.Example;
  InputDevices.SpaceMouseInput spaceMouseInput
    annotation (Placement(transformation(extent={{-20,40},{0,60}})));
  OperatingSystem.RealtimeSynchronize realtimeSynchronize
    annotation (Placement(transformation(extent={{-80,20},{-60,40}})));
  annotation (experiment(StopTime=5.0), Documentation(info="<html>
<p>
Basic example of using inputs from a <a href=\"http://www.3dconnexion.com/\">3Dconnexion SpaceMouse</a>.
</p>
<p>
<b>Important for Linux users:</b> In order to work under Linux it is needed that the <a href=\"http://www.3dconnexion.com/service/drivers.html\">linux drivers</a> provided by 3Dconnexion are installed and running.
</p>
</html>"));
end TestInputSpaceMouse;
