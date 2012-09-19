within Modelica_DeviceDrivers.Incubate.Interfaces;
connector SoftingCANIn
  import Modelica_DeviceDrivers.Incubate.SoftingCAN;
  input SoftingCAN softingCAN;
  output Real dummy;

  annotation (Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,
            -100},{100,100}},
        initialScale=0.2), graphics={Rectangle(
          extent={{-100,40},{100,-40}},
          fillColor={200,200,200},
          fillPattern=FillPattern.Sphere,
          pattern=LinePattern.None,
          lineColor={0,0,0}),
        Line(
          points={{-100,-40},{0,40},{100,-40}},
          color={95,95,95},
          smooth=Smooth.None),
        Line(
          points={{-52,-40},{0,0},{50,-40}},
          color={95,95,95},
          smooth=Smooth.None)}),Diagram(coordinateSystem(
        preserveAspectRatio=true,
        extent={{-100,-100},{100,100}},
        initialScale=0.2)));
end SoftingCANIn;
