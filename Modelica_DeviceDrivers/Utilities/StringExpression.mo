within Modelica_DeviceDrivers.Utilities;
block StringExpression "Set output to a (time varying) String expression"

  output String y="An example String" "Value of String output"
    annotation (Dialog(group=
          "Time varying output signal"), Placement(transformation(extent={{
            100,-10},{120,10}})));

  annotation (
    Icon(coordinateSystem(
        preserveAspectRatio=false,
        extent={{-100,-100},{100,100}},
        grid={2,2}), graphics={
        Rectangle(
          extent={{-100,40},{100,-40}},
          fillColor={235,235,235},
          fillPattern=FillPattern.Solid,
          borderPattern=BorderPattern.Raised),
        Text(
          extent={{-96,15},{96,-15}},
          textString="%y"),
        Text(
          extent={{-150,90},{140,50}},
          textString="%name",
          textColor={0,0,255})}),
    Documentation(info="<html>
<p>
The (time varying) String output of this block can be defined in its
parameter menu via variable <b>y</b>. The purpose is to support the
easy definition of String expressions in a block diagram.
</p>
</html>"));

end StringExpression;
