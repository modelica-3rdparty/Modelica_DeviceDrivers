within Modelica_DeviceDrivers;
package Utilities "Collection of utility elements used within the library"
  extends Modelica.Icons.UtilitiesPackage;
  constant String RootDir =  Modelica.Utilities.Files.loadResource("modelica://Modelica_DeviceDrivers/")
  "Deprecated package constant. Use loadResource(..) directly in concerned models.";
  annotation (
   preferredView="info",
   Documentation(info="<html>
<p>
This package contains auxiliary packages and elements to be used in context with this library.
</p>
</html>"));
end Utilities;
