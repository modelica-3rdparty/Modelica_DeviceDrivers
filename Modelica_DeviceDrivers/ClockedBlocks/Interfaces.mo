within Modelica_DeviceDrivers.ClockedBlocks;
package Interfaces
    extends Modelica.Icons.InterfacesPackage;

  connector PackageIn "Packager input connector"
    import Modelica_DeviceDrivers.Packaging.SerialPackager;

    input Modelica_DeviceDrivers.Packaging.SerialPackager pkg;
    input Real dummy;

    output Integer userPkgBitSize;
    output Integer autoPkgBitSize;
    annotation (defaultComponentName="pkgIn",
    Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,100}},
          initialScale=0.2), graphics={Rectangle(
            extent={{-100,40},{100,-40}},
            fillColor={255,255,0},
            fillPattern=FillPattern.Sphere,
            pattern=LinePattern.None),
          Line(
            points={{-100,-40},{0,40},{100,-40}},
            color={95,95,95}),
          Line(
            points={{-52,-40},{0,0},{50,-40}},
            color={95,95,95})}));
  end PackageIn;

  connector PackageOut "Packager output connector"
    import Modelica_DeviceDrivers.Packaging.SerialPackager;

    input Integer userPkgBitSize;
    input Integer autoPkgBitSize;

    output Modelica_DeviceDrivers.Packaging.SerialPackager pkg;
    /* Note: Could also encode initialization state into dummy variable. What is better? */
    /* output Boolean initialized "true, if initialization is done"; */
    output Real dummy;

    annotation (defaultComponentName="pkgOut",
    Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,100}},
          initialScale=0.2), graphics={Rectangle(
            extent={{-100,40},{100,-40}},
            fillColor={255,255,0},
            fillPattern=FillPattern.Sphere,
            pattern=LinePattern.None),
          Line(
            points={{-100,40},{0,-40},{100,40}},
            color={95,95,95}),
          Line(
            points={{-50,40},{2,0},{52,40}},
            color={95,95,95})}));
  end PackageOut;
end Interfaces;
