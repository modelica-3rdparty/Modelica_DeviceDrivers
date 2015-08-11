within Modelica_DeviceDrivers;
package Blocks "This package contains Modelica 3.2 compatible drag'n'drop device driver blocks."
  extends Modelica.Icons.Package;

  annotation (Icon(graphics={
      Rectangle(
        origin={0,35.1488},
        fillColor={255,255,255},
        extent={{-30.0,-20.1488},{30.0,20.1488}}),
      Rectangle(
        origin={0,-34.8512},
        fillColor={255,255,255},
        extent={{-30.0,-20.1488},{30.0,20.1488}}),
      Line(
        origin={-51.25,0},
        points={{21.25,-35.0},{-13.75,-35.0},{-13.75,35.0},{6.25,35.0}}),
      Polygon(
        origin={-40,35},
        pattern=LinePattern.None,
        fillPattern=FillPattern.Solid,
        points={{10.0,0.0},{-5.0,5.0},{-5.0,-5.0}}),
      Line(
        origin={51.25,0},
        points={{-21.25,35.0},{13.75,35.0},{13.75,-35.0},{-6.25,-35.0}}),
      Polygon(
        origin={40,-35},
        pattern=LinePattern.None,
        fillPattern=FillPattern.Solid,
        points={{-10.0,0.0},{5.0,5.0},{5.0,-5.0}})}),
                                          Documentation(info="<html>
<h4><font color=\"#008000\">Modelica 3.2 compatible block interface</font></h4>
<p>
The blocks provided in this package use Modelica 3.2 compatible <b>when</b>-clauses and the <b>sample</b>-operator to periodically call external Modelica functions that interface to the hardware drivers.
</p>
</html>"));
end Blocks;
