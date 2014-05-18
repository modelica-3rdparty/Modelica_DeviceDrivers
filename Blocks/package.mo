within Modelica_DeviceDrivers;
package Blocks "This package contains Modelica 3.2 compatible drag'n'drop device driver blocks."
  annotation (Icon(graphics={Rectangle(
          extent={{-80,100},{100,-80}},
          fillColor={215,230,240},
          fillPattern=FillPattern.Solid), Rectangle(
          extent={{-100,80},{80,-100}},
          fillColor={240,240,240},
          fillPattern=FillPattern.Solid),
      Rectangle(extent={{-32,-6},{16,-35}}),
      Rectangle(extent={{-32,-56},{16,-85}}),
      Line(points={{16,-20},{49,-20},{49,-71},{16,-71}}),
      Line(points={{-32,-72},{-64,-72},{-64,-21},{-32,-21}}),
      Polygon(
        points={{16,-71},{29,-67},{29,-74},{16,-71}},
        fillPattern=FillPattern.Solid),
      Polygon(
        points={{-32,-21},{-46,-17},{-46,-25},{-32,-21}},
        fillPattern=FillPattern.Solid)}), Documentation(info="<html>
<h4><font color=\"#008000\">Modelica 3.2 compatible block interface</font></h4>
<p>
The blocks provided in this package use Modelica 3.2 compatible <b>when</b>-clauses and the <b>sample</b>-operator to periodically call external Modelica functions that interface to the hardware drivers.
</p>
</html>"));
end Blocks;
