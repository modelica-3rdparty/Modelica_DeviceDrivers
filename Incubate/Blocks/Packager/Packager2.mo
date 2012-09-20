within Modelica_DeviceDrivers.Incubate.Blocks.Packager;
model Packager2 "Create package"
  extends Modelica.Icons.UnderConstruction;
  import Modelica_DeviceDrivers;

  Modelica_DeviceDrivers.Incubate.Interfaces.PackOut packOut
                                               annotation (Placement(
        transformation(extent={{-20,-128},{20,-88}}), iconTransformation(extent=
           {{-20,-128},{20,-88}})));
protected
    CANMessage msg = CANMessage();
equation
   packOut.msg = msg;
  annotation (Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},
            {100,100}}),       graphics={Bitmap(extent={{-70,70},{70,-70}},
            fileName="modelica://Modelica_DeviceDrivers/Resources/Images/Icons/package.PNG")}));
end Packager2;
