within Modelica_DeviceDrivers.Utilities.Icons;
partial block BusIcon "Icon for a communication bus"

  annotation (Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,
            -100},{100,100}}), graphics={
        Text(
          extent={{-150,102},{150,142}},
          textString="%name"),
        Line(
          points={{-92,0},{92,0}},
          rotation=360),
        Rectangle(
          extent={{-16,10},{16,-10}},
          fillPattern=FillPattern.Solid,
          fillColor={215,215,215},
          origin={-60,30},
          rotation=360),
        Line(
          points={{0,-10},{0,10}},
          origin={0,10},
          rotation=360),
        Line(
          points={{0,-10},{0,10}},
          origin={-60,10},
          rotation=360),
        Line(
          points={{0,-10},{0,10}},
          origin={60,10},
          rotation=360),
        Line(
          points={{0,-10},{0,10}},
          origin={-30,-10},
          rotation=360),
        Line(
          points={{0,-10},{0,10}},
          origin={30,-10},
          rotation=360),
        Rectangle(
          extent={{-16,10},{16,-10}},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          origin={0,30},
          rotation=360),
        Rectangle(
          extent={{-16,10},{16,-10}},
          fillPattern=FillPattern.Solid,
          fillColor={215,215,215},
          origin={60,30},
          rotation=360),
        Rectangle(
          extent={{-16,10},{16,-10}},
          fillPattern=FillPattern.Solid,
          fillColor={215,215,215},
          origin={30,-30},
          rotation=360),
        Rectangle(
          extent={{-16,10},{16,-10}},
          fillPattern=FillPattern.Solid,
          fillColor={215,215,215},
          origin={-30,-30},
          rotation=360)}));

end BusIcon;
