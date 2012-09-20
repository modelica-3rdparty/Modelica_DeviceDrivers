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
</html>",
        revisions="<html>
<img src=\"Modelica://Resources/Images/dlr_logo.png\"  width=60 >
 &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
 <b>      Copyright &copy; 2006-2007, DLR Institute of Robotics and Mechatronics</b>
</html>"));
end Utilities;
