within Modelica_DeviceDrivers.Utilities.Icons;
partial block BaseIcon
  "Base icon for blocks providing access to external devices"

  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics),
                            Icon(coordinateSystem(preserveAspectRatio=false,
          extent={{-100,-100},{100,100}}), graphics={Polygon(
          points={{0,-100},{-80,-100},{-88,-98},{-94,-94},{-98,-88},{-100,-80},
              {-100,80},{-98,88},{-94,94},{-88,98},{-80,100},{80,100},{88,98},{
              94,94},{98,88},{100,80},{100,-80},{98,-88},{94,-94},{88,-98},{80,
              -100},{0,-100}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid), Line(
          points={{0,-100},{-80,-100},{-88,-98},{-94,-94},{-98,-88},{-100,-80},
              {-100,80},{-98,88},{-94,94},{-88,98},{-80,100},{80,100},{88,98},{
              94,94},{98,88},{100,80},{100,-80},{98,-88},{94,-94},{88,-98},{80,
              -100},{0,-100}},
          color={0,64,127},
          thickness=0.5)}),
    Documentation(info="<html>
<p>
This partial class is intended to design a <em>default basic icon for a models of extenal interfaces</em>.
Since this is a base icon, it should be extended to represent specific model</p>
</html>"));
end BaseIcon;
