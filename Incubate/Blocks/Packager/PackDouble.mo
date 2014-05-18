within Modelica_DeviceDrivers.Incubate.Blocks.Packager;
model PackDouble "Pack IEEE double value (64 bit length) into CAN message"
  import Modelica_DeviceDrivers.Incubate.CANMessage;
  Modelica.Blocks.Interfaces.RealInput    u annotation (Placement(
        transformation(extent={{-140,-20},{-100,20}}), iconTransformation(
          extent={{-140,-20},{-100,20}})));
  Modelica_DeviceDrivers.Incubate.Interfaces.CANMessage msgOut annotation (
      Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=90,
        origin={108,0})));
equation
  when msgOut.trigger then
    CANMessage.doubleBitPacking(msgOut.msg, u);
  end when;

  annotation (Icon(graphics={
        Text(
          extent={{-130,58},{-30,-62}},
          lineColor={0,0,127},
          textString="I"),
        Polygon(
          points={{-10,0},{-30,20},{-30,10},{-60,10},{-60,-10},{-30,-10},{-30,-20},
              {-10,0}},
          lineColor={0,0,127},
          fillColor={0,0,127},
          fillPattern=FillPattern.Solid),Bitmap(extent={{10,36},{90,-44}},
            fileName="modelica://Modelica_DeviceDrivers/Resources/Images/Icons/package.PNG"),
        Text(
          extent={{-100,-46},{100,-74}},
          fillColor={0,0,127},
          fillPattern=FillPattern.Solid,
          textString="64 bit double"),
        Text(
          extent={{-100,72},{100,46}},
          fillColor={0,0,127},
          fillPattern=FillPattern.Solid,
          textString="Start bit: 0")}));
end PackDouble;
