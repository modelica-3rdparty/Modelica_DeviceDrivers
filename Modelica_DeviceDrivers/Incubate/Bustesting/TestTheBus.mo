within Modelica_DeviceDrivers.Incubate.Bustesting;
model TestTheBus

  Comp1 comp1_1
    annotation (Placement(transformation(extent={{-80,20},{-60,40}})));
  Comp2 comp2_1
    annotation (Placement(transformation(extent={{-20,20},{0,40}})));
equation
  connect(comp1_1.cANBus, comp2_1.cANBus) annotation (Line(
      points={{-60,31},{-20,31}},
      color={0,0,255}));
end TestTheBus;
