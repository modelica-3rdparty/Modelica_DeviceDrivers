within Modelica_DeviceDrivers.Incubate.Icons;
partial record DeviceIcon "Icon for device configuration"

  annotation (Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,
            -100},{100,100}}), graphics={
        Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,255},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-98,78},{98,96}},
          lineColor={0,0,255},
          fillColor={85,85,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-98,-98},{98,-80}},
          lineColor={0,0,255},
          fillColor={85,85,255},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-150,110},{150,150}},
          lineColor={0,0,255},
          fillColor={85,85,255},
          fillPattern=FillPattern.Solid,
          textString="%name"),
        Text(
          extent={{-66,4},{72,-54}},
          lineColor={0,0,0},
          textString="config"),
        Text(
          extent={{-66,44},{72,-14}},
          lineColor={0,0,0},
          textString="Device")}));

end DeviceIcon;
