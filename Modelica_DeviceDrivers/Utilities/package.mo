within Modelica_DeviceDrivers;
package Utilities "Collection of utility elements used within the library"
  extends Modelica.Icons.UtilitiesPackage;
  constant String RootDir=Modelica.Utilities.Files.fullPathName(classDirectory() + "..");
  annotation (
   preferredView="info",
   Documentation(info="<html>
<p>
This package contains auxiliary packages and elements to be used in context with the PowerTrain library.
</p>
</html>"));
end Utilities;
