within Modelica_DeviceDrivers.EmbeddedTargets.AVR.Examples.SBHS;
model BoardWithController
  extends .Modelica.Icons.Example;
  Modelica_DeviceDrivers.EmbeddedTargets.AVR.Examples.SBHS.Board sbhs annotation(Placement(visible = true, transformation(origin = {-2, 32}, extent = {{-30, -30}, {30, 30}}, rotation = 0)));
  Modelica.Blocks.Sources.IntegerConstant constantHeat(k = 50)  annotation(Placement(visible = true, transformation(origin = {-82, 20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica_DeviceDrivers.EmbeddedTargets.AVR.Examples.SBHS.Controller controller annotation(Placement(visible = true, transformation(origin = {-6, -34}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant constantSetpoint(k = 45)  annotation(Placement(visible = true, transformation(origin = {42, -74}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
equation
  connect(controller.setpoint, constantSetpoint.y) annotation(Line(points = {{6, -38}, {16, -38}, {16, -74}, {30, -74}, {30, -74}}, color = {0, 0, 127}));
  connect(sbhs.degC, controller.degC) annotation(Line(points = {{32, 32}, {74, 32}, {74, -30}, {6, -30}, {6, -28}}, color = {0, 0, 127}));
  connect(controller.fan, sbhs.fan) annotation(Line(points = {{-18, -34}, {-58, -34}, {-58, 46}, {-38, 46}, {-38, 46}}, color = {255, 127, 0}));
  connect(sbhs.heat, constantHeat.y) annotation(Line(points = {{-38, 20}, {-72, 20}, {-72, 20}, {-70, 20}}, color = {255, 127, 0}));
  annotation(experiment(Interval=0.008 /*125 Hz; sbhs.synchronizeRealtime1.actualInterval is not legal in experiment annotation*/));
end BoardWithController;
