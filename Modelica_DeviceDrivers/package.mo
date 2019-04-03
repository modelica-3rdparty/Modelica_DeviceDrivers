within ;
package Modelica_DeviceDrivers "Modelica_DeviceDrivers - A collection of drivers interfacing hardware like input devices, communication devices, shared memory, analog-digital converters and else"
  extends Modelica.Icons.Package;

  annotation (preferredView="info",
    uses(Modelica_Synchronous(version="0.92.1"),
       Modelica(version="3.2.3")),
    version="1.7.1",
    versionBuild=1,
    versionDate="2019-04-05",
    conversion(nonFromVersion="1.7.0", nonFromVersion="1.6.0"),
    Documentation(info="<html>
<p>
Library <b>Modelica_DeviceDrivers</b> is a Modelica package
that interfaces hardware drivers. There is support for input devices, communication devices,
shared memory, analog-digital converters and others.
</p>
<p><img src=\"modelica://Modelica_DeviceDrivers/Resources/Images/BlockOverview.png\"/></p>
<p>
For an introduction, have especially a look at:
</p>
<ul>
<li> <a href=\"modelica://Modelica_DeviceDrivers.UsersGuide.GettingStarted\">Getting started</a>
     provides an overview of the Library
     inside the <a href=\"modelica://Modelica_DeviceDrivers.UsersGuide\">User's Guide</a>.</li>
<li><a href=\"modelica://Modelica_DeviceDrivers.UsersGuide.ReleaseNotes\">Release Notes</a>
    summarizes the changes of new versions of this package.</li>
<li> <a href=\"modelica://Modelica_DeviceDrivers.UsersGuide.Contact\">Contact</a>
     gives author and acknowledgement information for this library.</li>
</ul>
<p>The library is developed at
<a href=\"https://github.com/modelica/Modelica_DeviceDrivers/\">https://github.com/modelica/Modelica_DeviceDrivers/</a>. You can
use the issue tracker provided by GitHub to report bugs or other issues
(<a href=\"https://github.com/modelica/Modelica_DeviceDrivers/issues\">https://github.com/modelica/Modelica_DeviceDrivers/issues</a>).</p>
<br>
<table border=\"0\" cellpadding=\"2\" cellspacing=\"2\">
<tr><td style=\"vertical-align: top;\">Copyright &copy; 2012-2019, DLR, ESI ITI, and Link&ouml;ping University (PELAB)</td>
</tr>
</table>

<p>
<i>This Modelica package is <u>free</u> software and
the use is completely at <u>your own risk</u>;
it can be redistributed and/or modified under the terms of the BSD 3-Clause License.</i>
</p>
<p>
<p>This also holds for the external C-code as again stated in file
<a href=\"modelica://Modelica_DeviceDrivers/Resources/License.txt\">Resources/License.txt</a>.
The partly optional third party sources / libraries with differing licenses are collected below the sub folder
<a href=\"modelica://Modelica_DeviceDrivers/Resources/thirdParty\">Resources/thirdParty</a> and are
listed in the file <a href=\"modelica://Modelica_DeviceDrivers/Resources/thirdParty/Readme.txt\">Resources/thirdParty/Readme.txt</a>.
</p>
</html>"),
  Icon(graphics={
          Bitmap(extent={{-78,-88},{100,92}}, fileName=
            "modelica://Modelica_DeviceDrivers/Resources/Images/Icons/gears.png")}));
end Modelica_DeviceDrivers;
