within Modelica_DeviceDrivers;
package Utilities "Collection of utility elements used within the library"
  extends Modelica.Icons.UtilitiesPackage;
  constant String RootDir =  Modelica.Utilities.Files.loadResource("modelica://Modelica_DeviceDrivers/")
  "Deprecated package constant. Use loadResource(..) directly in concerned models.";

  block TriggeredPrint
    "Block for debugging purposes. Prints a message at trigger instants."
    output String message= getInstanceName() annotation (Dialog(enable=true));
    Modelica.Blocks.Interfaces.BooleanInput trigger annotation (Placement(
          transformation(
          extent={{-20,-20},{20,20}},
          rotation=90,
          origin={0,-60})));
  equation
    when trigger then
      Modelica.Utilities.Streams.print(String(time) + " s: " + message);
    end when;
    annotation (Icon(coordinateSystem(
          preserveAspectRatio=false,
          extent={{-100,-100},{100,100}}), graphics={
          Rectangle(
            extent={{-100,40},{100,-40}},
            lineColor={0,0,0},
            lineThickness=5.0,
            fillColor={235,235,235},
            fillPattern=FillPattern.Solid,
            borderPattern=BorderPattern.Raised),
          Text(
            extent={{-88,16},{82,-14}},
            textColor={0,0,0},
            textString="%message"),
          Text(
            extent={{-150,90},{140,50}},
            textString="%name",
            textColor={0,0,255})}));
  end TriggeredPrint;

  annotation (
   preferredView="info",
   Documentation(info="<html>
<p>
This package contains auxiliary packages and elements to be used in context with this library.
</p>
</html>"));
end Utilities;
