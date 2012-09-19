within Modelica_DeviceDrivers.Incubate;
package Bustesting
  extends Modelica.Icons.UnderConstruction;
expandable connector CANBus
    "CAN bus that is adapted to the signals connected to it"
    import Modelica_DeviceDrivers.Incubate.*;
  extends Modelica.Icons.SignalBus;
  Real realSignal1 "First Real signal"  annotation(HideResult=false);
  Integer integerSignal "Integer signal"  annotation(HideResult=false);
  Boolean booleanSignal "Boolean signal"  annotation(HideResult=false);
  CAN_Msg1 cAN_Msg1 "CAN msg1"  annotation(HideResult=false);
  CAN_Msg2 cAN_Msg2 "CAN msg2"  annotation(HideResult=false);

end CANBus;

expandable connector CAN_Msg1 "CAN_msg1"
    import Modelica_DeviceDrivers.Incubate.*;
  extends Modelica.Icons.SignalBus;
  parameter Real myParam = 2 "testme";
  Real rSi1 "IEEE Double, startbit 1, signal"  annotation(HideResult=false);
  Integer iSig1 "Signed Integer signal"  annotation(HideResult=false);

end CAN_Msg1;

expandable connector CAN_Msg2 "CAN_msg2"
    import Modelica_DeviceDrivers.Incubate.*;
  extends Modelica.Icons.SignalBus;
  Real rSi1 "IEEE Double, startbit 1, signal"  annotation(HideResult=false);
  Integer iSig1 "Signed Integer signal"  annotation(HideResult=false);

end CAN_Msg2;

  model TestTheBus

    Comp1 comp1_1
      annotation (Placement(transformation(extent={{-80,20},{-60,40}})));
    Comp2 comp2_1
      annotation (Placement(transformation(extent={{-20,20},{0,40}})));
  equation
    connect(comp1_1.cANBus, comp2_1.cANBus) annotation (Line(
        points={{-60,31},{-20,31}},
        color={0,0,255},
        smooth=Smooth.None));
    annotation (Diagram(graphics));
  end TestTheBus;

  block Comp1
  extends Modelica.Blocks.Interfaces.BlockIcon;
    output CANBus cANBus annotation (Placement(transformation(
          extent={{-20,-20},{20,20}},
          rotation=270,
          origin={100,10})));
    Modelica.Blocks.Sources.Sine sine(freqHz=2)
      annotation (Placement(transformation(extent={{-60,20},{-40,40}})));
    Modelica.Blocks.Sources.IntegerStep integerStep(startTime=.2)
      annotation (Placement(transformation(extent={{-56,-22},{-36,-2}})));
    Modelica.Blocks.Sources.BooleanPulse booleanPulse(period=0.2)
      annotation (Placement(transformation(extent={{-50,-68},{-30,-48}})));
  protected
    CAN_Msg1 cAN_Msg1_1
      annotation (Placement(transformation(extent={{16,16},{56,56}})));
  equation

    connect(booleanPulse.y, cANBus.booleanSignal) annotation (Line(
        points={{-29,-58},{36,-58},{36,10},{100,10}},
        color={255,0,255},
        smooth=Smooth.None), Text(
        string="%second",
        index=1,
        extent={{6,3},{6,3}}));
    connect(sine.y, cAN_Msg1_1.rSi1) annotation (Line(
        points={{-39,30},{-4,30},{-4,36},{36,36}},
        color={0,0,127},
        smooth=Smooth.None), Text(
        string="%second",
        index=1,
        extent={{6,3},{6,3}}));
    connect(integerStep.y, cAN_Msg1_1.iSig1) annotation (Line(
        points={{-35,-12},{0,-12},{0,36},{36,36}},
        color={255,127,0},
        smooth=Smooth.None), Text(
        string="%second",
        index=1,
        extent={{6,3},{6,3}}));
    connect(cAN_Msg1_1, cANBus.cAN_Msg1) annotation (Line(
        points={{36,36},{67,36},{67,10},{100,10}},
        color={0,0,255},
        smooth=Smooth.None));
    annotation (Diagram(graphics));
  end Comp1;

  block Comp2
  extends Modelica.Blocks.Interfaces.BlockIcon;
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
        color={0,0,255},
        smooth=Smooth.None), Text(
        string="%first",
        index=-1,
        extent={{-6,3},{-6,3}}));
    connect(cANBus.cAN_Msg1.rSi1, gain.u) annotation (Line(
        points={{-100,10},{-72,10},{-72,34},{-42,34}},
        color={0,0,255},
        smooth=Smooth.None), Text(
        string="%first",
        index=-1,
        extent={{-6,3},{-6,3}}));
    connect(gain1.u, cANBus.cAN_Msg1.myParam) annotation (Line(
        points={{-42,76},{-42,47},{-100,47},{-100,10}},
        color={0,0,127},
        smooth=Smooth.None), Text(
        string="%second",
        index=1,
        extent={{6,3},{6,3}}));
    annotation (Diagram(graphics));
  end Comp2;

  record CANFrame "Record describing content of a CAN frame"
    extends Modelica.Icons.Record;
    parameter Integer nSignals=3;
    parameter Integer identifier = 100 "Identifier of CAN object/message";
    parameter CANSignal Signal[:];
  end CANFrame;

  record CANSignal
    extends Modelica.Icons.Record;
    Integer dataType = 1;
    Integer bitStartPosition(min=0,max=63) = 0
      "(min=0,max=63) Bit start position in CAN data field (CAN data field length is 64 bit)";
    Integer integerWidth = 32 "Integer width on CAN bus";
  end CANSignal;
end Bustesting;
