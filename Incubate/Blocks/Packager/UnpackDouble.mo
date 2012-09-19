within Modelica_DeviceDrivers.Incubate.Blocks.Packager;
model UnpackDouble "Extract IEEE double value (64 bit length) from CAN message"
  import Modelica_DeviceDrivers.Incubate.CANMessage;
  Interfaces.CANMessage      msgIn annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=90,
        origin={-108,-2})));
  Modelica.Blocks.Interfaces.RealOutput    y
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));
equation
  when msgIn.trigger then
    y = CANMessage.doubleBitUnpacking(msgIn.msg);
  end when;
  annotation (Diagram(coordinateSystem(preserveAspectRatio=true,  extent={{-100,
            -100},{100,100}}), graphics), Icon(graphics={
        Text(
          extent={{30,60},{130,-60}},
          lineColor={0,0,127},
          textString="I"),
        Polygon(
          points={{60,0},{40,20},{40,10},{10,10},{10,-10},{40,-10},{40,-20},{60,
              0}},
          lineColor={0,0,127},
          fillColor={0,0,127},
          fillPattern=FillPattern.Solid),Bitmap(extent={{-86,36},{-6,-44}},
            fileName="modelica://Modelica_DeviceDrivers/Resources/Images/Icons/package.PNG"),
        Text(
          extent={{-100,74},{100,48}},
          lineColor={0,0,0},
          fillColor={0,0,127},
          fillPattern=FillPattern.Solid,
          textString="Start bit:  0"),
        Text(
          extent={{-100,-48},{100,-76}},
          lineColor={0,0,0},
          fillColor={0,0,127},
          fillPattern=FillPattern.Solid,
          textString="64 bit double")}));
end UnpackDouble;
