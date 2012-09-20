within Modelica_DeviceDrivers.Blocks;
package Interfaces
    extends Modelica.Icons.InterfacesPackage;

  connector PackageIn "Packager input connector"
    import Modelica_DeviceDrivers.Packaging.SerialPackager;

    input Modelica_DeviceDrivers.Packaging.SerialPackager pkg;
    input Boolean trigger;
    input Real dummy;

    output Boolean backwardTrigger;
    output Integer userPkgBitSize;
    output Integer autoPkgBitSize;
    annotation (defaultComponentName="pkgIn",
    Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,100}},
          initialScale=0.2), graphics={Rectangle(
            extent={{-100,40},{100,-40}},
            fillColor={255,255,0},
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
  end PackageIn;

  connector PackageOut "Packager output connector"
    import Modelica_DeviceDrivers.Packaging.SerialPackager;

    input Boolean backwardTrigger;
    input Integer userPkgBitSize;
    input Integer autoPkgBitSize;

    output Modelica_DeviceDrivers.Packaging.SerialPackager
                         pkg;
    output Boolean trigger;
    output Real dummy;

    annotation (defaultComponentName="pkgOut",
    Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,100}},
          initialScale=0.2), graphics={Rectangle(
            extent={{-100,40},{100,-40}},
            fillColor={255,255,0},
            fillPattern=FillPattern.Sphere,
            pattern=LinePattern.None,
            lineColor={0,0,0}),
          Line(
            points={{-100,40},{0,-40},{100,40}},
            color={95,95,95},
            smooth=Smooth.None),
          Line(
            points={{-50,40},{2,0},{52,40}},
            color={95,95,95},
            smooth=Smooth.None)}),Diagram(coordinateSystem(
          preserveAspectRatio=true,
          extent={{-100,-100},{100,100}},
          initialScale=0.2)));
  end PackageOut;
end Interfaces;
