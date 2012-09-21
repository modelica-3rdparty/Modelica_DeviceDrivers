within Modelica_DeviceDrivers;
package Utilities "Library of utility classes usually not directly utilized by the user"
  extends Modelica.Icons.Package;

 constant String RootDir=Modelica.Utilities.Files.fullPathName(classDirectory() + "..");


  annotation (
   preferedView="info",
   classOrder={"BaseClasses", "*"},
   Documentation(info="<html>
<p>
This package contains auxiliary packages and elements to be used in context with the PowerTrain library.
</p>
</html>"));
end Utilities;
