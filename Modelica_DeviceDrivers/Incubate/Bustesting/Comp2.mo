within Modelica_DeviceDrivers.Incubate.Bustesting;
block Comp2
extends Modelica.Blocks.Icons.Block;
  input CANBus cANBus annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=90,
        origin={-100,10})));
  Modelica.Blocks.Math.Gain gain(k=1)
    annotation (Placement(transformation(extent={{-40,24},{-20,44}})));
  Modelica.Blocks.Math.IntegerToReal integerToReal
    annotation (Placement(transformation(extent={{-40,-20},{-20,0}})));
  Modelica.Blocks.Math.Gain gain1(k=1)
    annotation (Placement(transformation(extent={{-40,66},{-20,86}})));
equation

  connect(cANBus.cAN_Msg1.iSig1, integerToReal.u) annotation (Line(
      points={{-100,10},{-72,10},{-72,-10},{-42,-10}},
      color={0,0,255}), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}}));
  connect(cANBus.cAN_Msg1.rSi1, gain.u) annotation (Line(
      points={{-100,10},{-72,10},{-72,34},{-42,34}},
      color={0,0,255}), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}}));
  connect(gain1.u, cANBus.cAN_Msg1.myParam) annotation (Line(
      points={{-42,76},{-42,47},{-100,47},{-100,10}},
      color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}}));
end Comp2;
