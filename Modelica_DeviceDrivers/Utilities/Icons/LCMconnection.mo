within Modelica_DeviceDrivers.Utilities.Icons;
partial block LCMconnection "Base icon for models of network connections"

  annotation (Icon(coordinateSystem(preserveAspectRatio=false,
          extent={{-100,-100},{100,100}}), graphics={
        Line(points={{-80,0},{80,0}}, color={0,127,127}),
        Ellipse(
          extent={{-90,10},{-70,-10}},
          lineColor={0,127,127},
          fillColor={0,127,127},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-50,40},{-30,20}},
          lineColor={0,127,127},
          fillColor={0,127,127},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-20,-20},{0,-40}},
          lineColor={0,127,127},
          fillColor={0,127,127},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{10,40},{30,20}},
          lineColor={0,127,127},
          fillColor={0,127,127},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{40,-20},{60,-40}},
          lineColor={0,127,127},
          fillColor={0,127,127},
          fillPattern=FillPattern.Solid),
        Line(points={{-40,0},{-40,20}}, color={0,127,127}),
        Line(points={{-10,-20},{-10,0}}, color={0,127,127}),
        Line(points={{20,0},{20,20}}, color={0,127,127}),
        Line(points={{50,-20},{50,0}}, color={0,127,127})}),
    Documentation(info="<html>
<p>
This partial class is intended to design a <em>default icon for a network connection model</em>.
</p>
</html>"));
end LCMconnection;
