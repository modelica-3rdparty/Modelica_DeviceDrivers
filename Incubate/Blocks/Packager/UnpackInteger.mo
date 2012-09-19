within Modelica_DeviceDrivers.Incubate.Blocks.Packager;
model UnpackInteger "Extract integer value from CAN message"
  import Modelica_DeviceDrivers.Incubate.CANMessage;
  parameter Integer bitStartPosition(min=0, max=63) = 0
    "Data bit position where reading shall start (0-63 bits)";
  parameter Integer length(min=0, max=32) = 32
    "Bit length that encodes the integer value";
  Interfaces.CANMessage      msgIn annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=90,
        origin={-108,-2})));
  Modelica.Blocks.Interfaces.IntegerOutput y
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));
equation
  when msgIn.trigger then
    y = CANMessage.integerBitUnpacking(msgIn.msg, bitStartPosition, length);
  end when;
  annotation (Diagram(coordinateSystem(preserveAspectRatio=true,  extent={{-100,
            -100},{100,100}}), graphics), Icon(graphics={
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
end UnpackInteger;
