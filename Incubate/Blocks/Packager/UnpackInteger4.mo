within Modelica_DeviceDrivers.Incubate.Blocks.Packager;
model UnpackInteger4 "Extract integer value from CAN message"
  extends Modelica.Icons.UnderConstruction;
  import Modelica_DeviceDrivers.Incubate.CANMessage;
  parameter Integer bitStartPosition(min=0, max=63) = 0
    "Data bit position where reading shall start (0-63 bits)";
  parameter Integer length(min=0, max=32) = 32
    "Bit length that encodes the integer value";
  Modelica.Blocks.Interfaces.IntegerOutput y
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));
  Interfaces.PackReadIn packReadIn annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=270,
        origin={-108,0})));
equation
  when packReadIn.trigger then
    y = CANMessage.integerBitUnpacking(packReadIn.msg, bitStartPosition, length);
  end when;
  annotation (Icon(graphics={
        Text(
          extent={{30,60},{130,-60}},
          lineColor={255,127,0},
          textString="I"),
        Polygon(
          points={{60,0},{40,20},{40,10},{10,10},{10,-10},{40,-10},{40,-20},{60,
              0}},
          lineColor={255,127,0},
          fillColor={255,127,0},
          fillPattern=FillPattern.Solid),Bitmap(extent={{-86,36},{-6,-44}},
            fileName="modelica://Modelica_DeviceDrivers/Resources/Images/Icons/package.PNG"),
        Text(
          extent={{-100,74},{100,48}},
          lineColor={0,0,0},
          fillColor={0,0,127},
          fillPattern=FillPattern.Solid,
          textString="Start bit:  %bitStartPosition"),
        Text(
          extent={{-100,-46},{100,-74}},
          lineColor={0,0,0},
          fillColor={0,0,127},
          fillPattern=FillPattern.Solid,
          textString="Length: %length bits")}));
end UnpackInteger4;
