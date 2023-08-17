within Modelica_DeviceDrivers.EmbeddedTargets.AVR.Examples.SBHS;
model BoardWithController
  extends .Modelica.Icons.Example;
  Modelica_DeviceDrivers.EmbeddedTargets.AVR.Examples.SBHS.Board sbhs annotation(Placement(visible = true, transformation(origin = {-2, 32}, extent = {{-30, -30}, {30, 30}}, rotation = 0)));
  Modelica.Blocks.Sources.IntegerConstant constantHeat(k = 50)  annotation(Placement(visible = true, transformation(origin = {-82, 20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica_DeviceDrivers.EmbeddedTargets.AVR.Examples.SBHS.Controller controller annotation(Placement(visible = true, transformation(origin = {-6, -34}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant constantSetpoint(k = 45)  annotation(Placement(visible = true, transformation(origin={42,-60},    extent = {{10, -10}, {-10, 10}}, rotation = 0)));
equation
  connect(controller.setpoint, constantSetpoint.y) annotation(Line(points={{6,-38.4},
          {16,-38.4},{16,-60},{31,-60}},                                                                                            color = {0, 0, 127}));
  connect(sbhs.degC, controller.degC) annotation(Line(points={{31,32},{74,32},{
          74,-30},{6,-30},{6,-29}},                                                                                 color = {0, 0, 127}));
  connect(controller.fan, sbhs.fan) annotation(Line(points={{-17,-33.6},{-58,
          -33.6},{-58,46},{-38,46},{-38,45.8}},                                                                         color = {255, 127, 0}));
  connect(sbhs.heat, constantHeat.y) annotation(Line(points={{-38,20},{-72,20},
          {-71,20}},                                                                                        color = {255, 127, 0}));
                                       /*125 Hz; sbhs.synchronizeRealtime1.actualInterval is not legal in experiment annotation*/
  annotation(experiment(Interval=0.008), Diagram(graphics={
                              Text(
          extent={{-94,-74},{96,-102}},
          textColor={0,0,255},
          textString=
              "Please see the AVR package documentation before testing the example!")}));
end BoardWithController;
