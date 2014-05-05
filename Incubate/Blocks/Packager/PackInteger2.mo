within Modelica_DeviceDrivers.Incubate.Blocks.Packager;
model PackInteger2 "Pack integer value into CAN message"
    extends Modelica.Icons.UnderConstruction;
  import Modelica_DeviceDrivers.Incubate.CANMessage;
  parameter Integer bitStartPosition(min=0, max=63) = 0
    "Data bit position where writing shall start (0-63 bits)";
  parameter Integer length(min=0, max=32) = 32
    "Bit-length of region encoding the integer value";
  Modelica.Blocks.Interfaces.IntegerInput u annotation (Placement(
        transformation(extent={{-140,-20},{-100,20}}), iconTransformation(
          extent={{-140,-20},{-100,20}})));
  Interfaces.PackOut  msgOut annotation (
      Placement(transformation(
        extent={{-20,-20},{20,20}},
        origin={0,-108})));
  Interfaces.PackIn msgIn
    annotation (Placement(transformation(extent={{-20,88},{20,128}})));
equation
  msgOut = msgIn;
  when msgOut.trigger then
    CANMessage.integerBitPacking(msgOut.msg, bitStartPosition, length, u);
  end when;

  annotation (Icon(graphics={
        Text(
          extent={{-130,58},{-30,-62}},
          lineColor={255,127,0},
          textString="I"),
        Polygon(
          points={{-10,0},{-30,20},{-30,10},{-60,10},{-60,-10},{-30,-10},{-30,-20},
              {-10,0}},
          lineColor={255,127,0},
          fillColor={255,127,0},
          fillPattern=FillPattern.Solid),Bitmap(extent={{10,36},{90,-44}},
            fileName="modelica://Modelica_DeviceDrivers/Resources/Images/Icons/package.PNG"),
        Text(
          extent={{-100,74},{100,48}},
          lineColor={0,0,0},
          fillColor={0,0,127},
          fillPattern=FillPattern.Solid,
          textString="Start bit:  %bitStartPosition"),
        Text(
          extent={{-100,-44},{100,-72}},
          lineColor={0,0,0},
          fillColor={0,0,127},
          fillPattern=FillPattern.Solid,
          textString="Length: %length bits")}));
end PackInteger2;
