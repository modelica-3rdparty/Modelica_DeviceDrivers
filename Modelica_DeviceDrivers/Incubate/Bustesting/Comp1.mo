within Modelica_DeviceDrivers.Incubate.Bustesting;
block Comp1
extends Modelica.Blocks.Icons.Block;
  output CANBus cANBus annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=270,
        origin={100,10})));
  Modelica.Blocks.Sources.Sine sine(f=2)
    annotation (Placement(transformation(extent={{-60,20},{-40,40}})));
  Modelica.Blocks.Sources.IntegerStep integerStep(startTime=0.2)
    annotation (Placement(transformation(extent={{-56,-22},{-36,-2}})));
  Modelica.Blocks.Sources.BooleanPulse booleanPulse(period=0.2)
    annotation (Placement(transformation(extent={{-50,-68},{-30,-48}})));
protected
  CAN_Msg1 cAN_Msg1_1
    annotation (Placement(transformation(extent={{16,16},{56,56}})));
equation

  connect(booleanPulse.y, cANBus.booleanSignal) annotation (Line(
      points={{-29,-58},{36,-58},{36,10},{100,10}},
      color={255,0,255}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}}));
  connect(sine.y, cAN_Msg1_1.rSi1) annotation (Line(
      points={{-39,30},{-4,30},{-4,36},{36,36}},
      color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}}));
  connect(integerStep.y, cAN_Msg1_1.iSig1) annotation (Line(
      points={{-35,-12},{0,-12},{0,36},{36,36}},
      color={255,127,0}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}}));
  connect(cAN_Msg1_1, cANBus.cAN_Msg1) annotation (Line(
      points={{36,36},{67,36},{67,10},{100,10}},
      color={0,0,255}));
end Comp1;
