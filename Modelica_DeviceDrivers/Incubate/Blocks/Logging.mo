within Modelica_DeviceDrivers.Incubate.Blocks;
package Logging "a collection of logging blocks"
    extends Modelica.Icons.Package;
  model LogVector "Logs a vector to disk in csv format"
  extends Modelica_DeviceDrivers.Utilities.Icons.BaseIcon;
  parameter String filename = "result.log" "Filename for the logging file";
    parameter Modelica.Units.SI.Period sampleTime=0.01 "Sample time of logging";
  parameter Integer n=1 "Vector size";

    Modelica.Blocks.Interfaces.RealInput u[n]
      annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
  equation
    when sample(0,sampleTime) then
      Modelica.Utilities.Streams.print(Modelica_DeviceDrivers.Incubate.Utilities.Functions.vectorToString(u),filename);
    end when;
    annotation (Icon(graphics={Ellipse(extent={{-80,0},{80,-60}},   lineColor={0,0,
                255},
            fillColor={135,135,135},
            fillPattern=FillPattern.Solid),
                               Ellipse(extent={{-80,28},{80,-32}},  lineColor={0,0,
                255},
            fillColor={135,135,135},
            fillPattern=FillPattern.Solid),
                               Ellipse(extent={{-80,52},{80,-8}},   lineColor={0,0,
                255},
            fillColor={135,135,135},
            fillPattern=FillPattern.Solid),
          Line(
            points={{-102,0},{-86,0},{-86,68},{0,68},{0,34}},
            color={0,0,255}),
          Polygon(
            points={{-16,34},{16,34},{0,12},{-16,34}},
            lineColor={0,0,255},
            fillColor={0,0,255},
            fillPattern=FillPattern.Solid)}));
  end LogVector;
end Logging;
