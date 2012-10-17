within Modelica_DeviceDrivers.Utilities.Icons;
record ComediRecordIcon
  "Icon for comedi records (Tux from JZA placed into the public domain, http://openclipart.org/detail/168653/tux-enhanced-by-jza)."

  annotation (Icon(graphics={
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
          Bitmap(extent={{10,-22},{112,-92}},fileName="modelica://Modelica_DeviceDrivers/Resources/Images/Icons/tux-enhanced.png"),
                                         Text(extent={{-150,142},{150,102}},
            textString="%name")}));
end ComediRecordIcon;
