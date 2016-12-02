within Modelica_DeviceDrivers;
package EmbeddedTargets
  extends Utilities.Icons.GenericICPackage;
  annotation (
   preferredView="info",
   Documentation(info="<html>
<p>
This package contains code for platform-specific targets, such as
microcontrollers that cannot share code with other devices due to
memory or hardware limitations. There is one package for each target,
and it contains Blocks, Constants, Functions, and Types specific for
this particular target.
</p>
</html>"));
end EmbeddedTargets;
