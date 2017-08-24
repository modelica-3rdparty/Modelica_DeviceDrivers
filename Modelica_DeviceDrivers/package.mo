within ;
package Modelica_DeviceDrivers "Modelica_DeviceDrivers - A collection of drivers interfacing hardware like input devices, communication devices, shared memory, analog-digital converters and else"
  extends Modelica.Icons.Package;

  annotation (preferredView="info",
    uses(Modelica_Synchronous(version="0.92.1"),
       Modelica(version="3.2.2")),
    version="1.5.0",
    versionDate="2017-05-12",
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
<a href=\"https://github.com/modelica/Modelica_DeviceDrivers/\">https://github.com/modelica/Modelica_DeviceDrivers/</a>
(switch to the <i>master</i> branch for the latest development version). You can
use the issue tracker provided by GitHub to report bugs or other issues
(<a href=\"https://github.com/modelica/Modelica_DeviceDrivers/issues\">https://github.com/modelica/Modelica_DeviceDrivers/issues</a>).</p>
<br>
<table border=\"0\" cellpadding=\"2\" cellspacing=\"2\">
<tr><td style=\"vertical-align: top;\">Copyright &copy; 2014-2017, Link&ouml;ping University (PELAB), ESI ITI GmbH, and DLR Institute of System Dynamics and Control</td>
</tr>
<tr><td style=\"vertical-align: top;\">Copyright &copy; 2012-2013, DLR Institute of System Dynamics and Control</td></tr>
</table>

<p>
<i>This Modelica package is <u>free</u> software and
the use is completely at <u>your own risk</u>;
it can be redistributed and/or modified under the terms of the
Modelica license 2, see the license conditions (including the
disclaimer of warranty)
<a href=\"modelica://Modelica_DeviceDrivers.UsersGuide.ModelicaLicense2\">here</a>
or at
<a href=\"http://www.Modelica.org/licenses/ModelicaLicense2\">
http://www.Modelica.org/licenses/ModelicaLicense2</a>.</i>
</p>
<p>Furthermore, this libray depends on (free) external C-code which is licensed under
liberal <i>Simplified BSD License</i> terms stated in file
<a href=\"modelica://Modelica_DeviceDrivers/Resources/License.txt\">Resources/License.txt</a>.
Partly optional third party sources / libraries with differing licenses are collected below the sub folder
<a href=\"modelica://Modelica_DeviceDrivers/Resources/thirdParty\">Resources/thirdParty</a> and
listed in file <a href=\"modelica://Modelica_DeviceDrivers/Resources/thirdParty/Readme.txt\">Resources/thirdParty/Readme.txt</a>.
</html>"),
  Icon(graphics={
          Bitmap(extent={{-78,-88},{100,92}}, fileName=
            "modelica://Modelica_DeviceDrivers/Resources/Images/Icons/gears.png")}));
end Modelica_DeviceDrivers;
