within Modelica_DeviceDrivers.Utilities.Icons;
partial record SocketCANRecordIcon
  "Icon for Socket CAN (Tux from JZA placed into the public domain, http://openclipart.org/detail/168653/tux-enhanced-by-jza)."

  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,
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
          fillPattern=FillPattern.Solid),Text(extent={{-150,142},{150,102}},
            textString="%name"),
          Bitmap(extent={{16,-24},{118,-94}},fileName="modelica://Modelica_DeviceDrivers/Resources/Images/Icons/tux-enhanced.png"),
        Line(
          points={{-92,0},{92,0}},
          origin={-2,0},
          rotation=360),
        Rectangle(
          extent={{-16,10},{16,-10}},
          fillPattern=FillPattern.Solid,
          fillColor={215,215,215},
          origin={-62,30},
          rotation=360),
        Line(
          points={{0,-10},{0,10}},
          origin={-2,10},
          rotation=360),
        Line(
          points={{0,-10},{0,10}},
          origin={-62,10},
          rotation=360),
        Line(
          points={{0,-10},{0,10}},
          origin={58,10},
          rotation=360),
        Line(
          points={{0,-10},{0,10}},
          origin={-32,-10},
          rotation=360),
        Line(
          points={{0,-10},{0,10}},
          origin={28,-10},
          rotation=360),
        Rectangle(
          extent={{-16,10},{16,-10}},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          origin={-2,30},
          rotation=360),
        Rectangle(
          extent={{-16,10},{16,-10}},
          fillPattern=FillPattern.Solid,
          fillColor={215,215,215},
          origin={58,30},
          rotation=360),
        Rectangle(
          extent={{-16,10},{16,-10}},
          fillPattern=FillPattern.Solid,
          fillColor={215,215,215},
          origin={28,-30},
          rotation=360),
        Rectangle(
          extent={{-16,10},{16,-10}},
          fillPattern=FillPattern.Solid,
          fillColor={215,215,215},
          origin={-32,-30},
          rotation=360)}));
end SocketCANRecordIcon;
