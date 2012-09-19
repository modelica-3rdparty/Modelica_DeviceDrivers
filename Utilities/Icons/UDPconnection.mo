within Modelica_DeviceDrivers.Utilities.Icons;
partial block UDPconnection "Base icon for models of network connections"

  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}),
                      graphics),
                            Icon(coordinateSystem(preserveAspectRatio=false,
          extent={{-100,-100},{100,100}}), graphics={
        Line(points={{-80,0},{80,0}}, color={65,65,65}),
        Ellipse(
          extent={{-90,10},{-70,-10}},
          lineColor={65,65,65},
          fillColor={65,65,65},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-50,40},{-30,20}},
          lineColor={65,65,65},
          fillColor={65,65,65},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-20,-20},{0,-40}},
          lineColor={65,65,65},
          fillColor={65,65,65},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{10,40},{30,20}},
          lineColor={65,65,65},
          fillColor={65,65,65},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{40,-20},{60,-40}},
          lineColor={65,65,65},
          fillColor={65,65,65},
          fillPattern=FillPattern.Solid),
        Line(points={{-40,0},{-40,20}}, color={65,65,65}),
        Line(points={{-10,-20},{-10,0}}, color={65,65,65}),
        Line(points={{20,0},{20,20}}, color={65,65,65}),
        Line(points={{50,-20},{50,0}}, color={65,65,65})}),
    Documentation(info="<html>
<p>
This partial class is intended to design a <em>default icon for a network connection model</em>.
</p>
</html>"));
end UDPconnection;
