within Modelica_DeviceDrivers.Incubate.Icons;
partial record BusIconRecord "Icon for a communication bus"

  annotation (Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,
            -100},{100,100}}), graphics={
        Text(
          extent={{-150,110},{150,150}},
          lineColor={0,0,255},
          fillColor={85,85,255},
          fillPattern=FillPattern.Solid,
          textString="%name"),
        Line(
          points={{-92,0},{92,0}},
          color={0,0,0},
          smooth=Smooth.None),
        Rectangle(
          extent={{-76,40},{-44,20}},
          lineColor={0,0,0},
          fillPattern=FillPattern.Solid,
          fillColor={215,215,215}),
        Line(
          points={{0,0},{0,20}},
          color={0,0,0},
          smooth=Smooth.None),
        Line(
          points={{-60,0},{-60,20}},
          color={0,0,0},
          smooth=Smooth.None),
        Line(
          points={{60,0},{60,20}},
          color={0,0,0},
          smooth=Smooth.None),
        Line(
          points={{-30,-20},{-30,0}},
          color={0,0,0},
          smooth=Smooth.None),
        Line(
          points={{30,-20},{30,0}},
          color={0,0,0},
          smooth=Smooth.None),
        Rectangle(
          extent={{-16,40},{16,20}},
          lineColor={0,0,0},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{44,40},{76,20}},
          lineColor={0,0,0},
          fillPattern=FillPattern.Solid,
          fillColor={215,215,215}),
        Rectangle(
          extent={{14,-20},{46,-40}},
          lineColor={0,0,0},
          fillPattern=FillPattern.Solid,
          fillColor={215,215,215}),
        Rectangle(
          extent={{-46,-20},{-14,-40}},
          lineColor={0,0,0},
          fillPattern=FillPattern.Solid,
          fillColor={215,215,215})}));

end BusIconRecord;
