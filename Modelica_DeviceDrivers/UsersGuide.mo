within Modelica_DeviceDrivers;
package UsersGuide "User's Guide"
    extends Modelica.Icons.Information;

  class GettingStarted "Getting started"
      extends Modelica.Icons.Information;

    annotation (Documentation(info="<html>
<p>In this section, a first introduction to the Modelica_DeviceDrivers library is given at hand of several examples.</p>
<h4>Introduction</h4>
<p>The library allows to access some selected external devices in Modelica models. This is achieved by using the Modelica external C interface to call the appropriate C driver functions provided by the underlying operating system. Currently MS Windows and Linux are supported.</p>
<p>The library is organized in several layers as indicated below. It is noteworthy that the library provides two high-level Drag &amp; Drop block interfaces. The first (.Blocks) is compatible to Modelica 3.2, using the traditional &quot;when sample()&quot; element for periodically calling Modelica functions from the Function Layer. The second (.ClockedBlocks) uses the<i> Synchronous Language Elements</i> extension introduced in Modelica 3.3 for periodic execution.</p>
<p><img src=\"modelica://Modelica_DeviceDrivers/Resources/Images/DeviceDrivers_LayeredArchitecture.png\"/></p>
<h4>Usage Examples</h4>
<p>Looking at the examples in <code>.Blocks.Examples</code> (or <code>.ClockedBlocks.Examples</code>, respectively) the usage of the library should be self-explanatory. In the following two exemplarily examples are considered.</p>
<h5>User Input devices</h5>
<p> E.g., using a joystick or gamepad as input for a real-time simulation just requires to drag &amp; drop two blocks: <code>.Blocks.OperatingSystem.SynchronizeRealtime</code> and <code>.Blocks.InputDevices.JoystickInput</code> (or respectively, <code>.ClockedBlocks.OperatingSystem.SynchronizeRealtime</code> and <code>.ClockedBlocks.InputDevices.JoystickInput</code>). See the executable example at <code>.(Clocked)Blocks.Examples.TestInputJoystick</code>:</p>
<p><img src=\"modelica://Modelica_DeviceDrivers/Resources/Images/TestInputJoystick.png\"/></p>
<p>The <code>SynchronizeRealtime</code> block synchronizes the simulation time with the operating systems real-time clock. That allows interactive Modelica simulations, e.g., a vehicle driving simulation using a gamepad for user inputs.</p>
<h5>Communication Devices</h5>
<p>Communication devices like UDP or shared memory use a common packaging concept in order to send or receive data. Therefore the same Packager can be used with different communication devices, as indicated in the figure below.</p>
<p><img src=\"modelica://Modelica_DeviceDrivers/Resources/Images/PackagingConcept.png\"/></p>
</html>"));
  end GettingStarted;

  class Requirements "Requirements"
    extends Modelica.Icons.Information;
    annotation (Documentation(info="<html>
<p>
The tool must support the Modelica external function interface as specified in Section 12.9 of the Modelica specification 3.2 and later.
</p>
<p>
<b>Optionally</b> following requirements need to be additionally satisfied.
</p>
<ol>
<li>For the (optional) use of the blocks provided in
<a href=\"modelica://Modelica_DeviceDrivers.ClockedBlocks\">ClockedBlocks</a> the
tool needs support for the Modelica 3.3 language elements of Chapter 16
\"Synchronous Language Elements\" of the Modelica Language Specification 3.3 </li>
<li>
The examples provided for the ClockedBlocks depend on the
<a href=\"modelica://Modelica_Synchronous\">Modelica_Synchronous</a> library.</li>
</ol>
<p>
Please note that the package <a href=\"modelica://Modelica_DeviceDrivers.Blocks\">Blocks</a>
realizes similar functionality as provided by ClockedBlocks, but is also usable by tools
that have no support for the synchronous language elements.
</p>
<h4>Modelica tools known to work with that library</h4>
<p>The library is known to work with</p>
<ul>
<li>Dymola,</li>
<li>SimulationX (with userBufferSize all non-clocked communication blocks are working
in SimulationX, but autoBufferSize only works for external solvers
CVode and Fixed Step solver and fails for BDF and MEBDF solvers),</li>
<li>OpenModelica (partial support starting with OpenModelica v1.12.0 beta, e.g., UDP, serial port, shared memory,
LCM, keyboard).</li>
</ul>
</html>"));
  end Requirements;

  class References "References"
    extends Modelica.Icons.References;
    annotation (Documentation(info="<html>
<p>
This library is based on various resources (mainly within the internet) describing the C-APIs of the devices supported in this library. Amongst others, following references were used:
</p>
<dl>
<dt>MSDN (2012):</dt>
<dd> <b>Microsoft Developer Network</b>.
      <a href=\"http://msdn.microsoft.com/\">http://msdn.microsoft.com/</a>. <br>&nbsp;</dd>
<dt>Robert Love (2007):</dt>
<dd> <b>Linux System Programming</b>.
      O'Reilly Media. <br>&nbsp;</dd>
<dt>Linux Man Pages (2012):</dt>
<dd> e.g., <a href=\"http://linux.die.net/man/\">http://linux.die.net/man/</a>. <br>&nbsp;</dd>
<dt>The IEEE and The Open Group (2004):</dt>
<dd> <b>The Open Group Base Specifications Issue 6</b>.
      <a href=\"http://pubs.opengroup.org/onlinepubs/009695399/\">http://pubs.opengroup.org/onlinepubs/009695399/</a>. <br>&nbsp;</dd>
</dl>
</html>"));
  end References;

  package ReleaseNotes "Release notes"
    extends Modelica.Icons.ReleaseNotes;
    class Version_1_5_1 "Version 1.5.1 (September 19, 2017)"
    extends Modelica.Icons.ReleaseNotes;

  annotation (Documentation(info="<html>
<ul>
<li>
Bug fix for variable name spelling error in <code>Blocks.InputDevices.JoystickInput</code> (<a href=\"https://github.com/modelica/Modelica_DeviceDrivers/issues/224\">#224</a>)
</li>
</ul>
</html>"));
      end Version_1_5_1;

    class Version_1_5_0 "Version 1.5.0 (May 12, 2017)"
    extends Modelica.Icons.ReleaseNotes;

  annotation (Documentation(info="<html>
<ul>
<li>
<b>Important:</b> A bug fix in the shared memory implementation for <i>Windows</i>
potentially affects applications that adapted the (wrong) buffer layout
(see PR <a href=\"https://github.com/modelica/Modelica_DeviceDrivers/pull/138\">#138</a>)!
</li>
<li>Presentation of the library at the
<a href=\"https://www.modelica.org/events/modelica2017/proceedings/html/submissions/ecp17132713_ThieleBeutlichWaurichSjolundBellmann.pdf\">Modelica'2017 conference</a>.
</li>
<li>
OpenModelica (v1.11.0 Beta 1 and later) is now the third tool known to (partially) support the library
(e.g., UDP, TCP/IP, serial port, shared memory, and LCM communication).
</li>
<li>
Added support for sending and receiving of Lightweight Communications and Marshalling
<a href=\"https://lcm-proj.github.io\">LCM</a> datagrams (only the communication aspect of LCM is considered,
see example <a href=\"modelica://Modelica_DeviceDrivers.Blocks.Examples.TestSerialPackager_LCM\">TestSerialPackager_LCM</a>).
</li>
<li>
Added support for TCP/IP communication for Linux (was already available for Windows).
</li>
<li>
New top-level package <a href=\"modelica://Modelica_DeviceDrivers.EmbeddedTargets\">EmbeddedTargets</a>
with a first prototypical support for the
Atmel AVR family of microcontrollers (ATmega16 and ATmega328P (=Arduino Uno) are supported; currently only known to work with OpenModelica's
ExperimentalEmbeddedC code generation, see
<a href=\"modelica://Modelica_DeviceDrivers.EmbeddedTargets.AVR\">AVR documentation</a>).
</li>
<li>
Bug fixes for the serial port support.
</li>
<li>
Bug fix for the byte order swapping logic (endianness, <a href=\"https://github.com/modelica/Modelica_DeviceDrivers/issues/203\">#203</a>).
</li>
<li>
Other (minor) fixes and improvements.
</li>
</ul>
</html>"));
      end Version_1_5_0;

    class Version_1_4_4 "Version 1.4.4 (April 12, 2016)"
      extends Modelica.Icons.ReleaseNotes;

      annotation (Documentation(info="<html>
<ul>
<li>Bug fix release, no new features, but many improvements since version v1.4.0 (more than 70 commits since v1.4.0), so let's list some of the improvements...</li>
<li>Uses latest version of Modelica Standard Library (v3.2.2).</li>
<li>Changed license of external C code and header files to <a href=\"modelica://Modelica_DeviceDrivers/Resources/License.txt\">Simplified BSD License</a>.</li> (the Modelica package parts remain under
<a href=\"modelica://Modelica_DeviceDrivers.UsersGuide.ModelicaLicense2\">Modelica License 2</a>).
<li>Improved Modelica compatibility: Fixed the use of conditionally enabled variable <code>procPrio</code> outside of connect in <code>Blocks.OperatingSystem.SynchronizeRealtime</code> and <code>ClockedBlocks.OperatingSystem.SynchronizeRealtime</code>.</li>
<li>Improved Modelica compatibility: Fixed the invalid integer to enumeration type conversion in <code>HardwareIO</code>.</li>
<li>Fully specified the initial conditions for example models.</li>
<li>Simplified the linking with system libraries (MSVC only).</li>
<li>Added continuous integration for the external C code (thanks to <a href=\"https://travis-ci.org/modelica/Modelica_DeviceDrivers\">Travis CI</a>).</li>
<li>Improved compatibility with the DLR Visualization Library.</li>
<li>Improved support of automatic Code-Export from SimulationX 3.7.</li>
<li>Fixes for the clocked communication blocks (added missing <code>byteOrder</code> support).</li>
<li>Other (minor) fixes.</li>
</ul>
</html>"));
    end Version_1_4_4;

    class Version_1_4_0 "Version 1.4.0 (Sep 01, 2015)"
      extends Modelica.Icons.ReleaseNotes;

      annotation (Documentation(info="<html>
<ul>
<li>Switched to <a href=\"http://semver.org/\">semantic versioning</a>.</li>
<li>Migrated to new release process motivated by <a href=\"https://github.com/xogeny/impact/blob/master/resources/docs/modelica2015/paper/impact.md#impact-on-library-developers\">impact-on-library-developers</a>.</li>
<li>Added support for external trigger signals to trigger communication blocks.</li>
<li>Added support to configure byte ordering in communication blocks.</li>
<li>Added support for TCP/IP communication for Windows.</li>
<li>Added serial port support for Windows (was already available for Linux).</li>
<li>Added compiler support for MinGW and Cygwin.</li>
<li>Added support for all 32 joystick buttons.</li>
<li>Fixed Modelica compatibility of output buffers in communication blocks.</li>
<li>Fixed multi-threaded access of UDP and shared memory communication for Windows.</li>
<li>Fixed many small issues, particularly for improved compatibility with SimulationX.</li>
</ul>
</html>"));
    end Version_1_4_0;

    class Version_1_3 "Version 1.3 (May 19, 2014)"
      extends Modelica.Icons.ReleaseNotes;

      annotation (Documentation(info="<html>
<ul>
<li>Fixed many issues in order to support SimulationX.</li>
<li>Particularly, a SimulationX compatible wrapper DLL to give access to the external C functions was added.</li>
<li>Added serial port support for Linux.</li>
</ul>
</html>"));
    end Version_1_3;

    class Version_1_2 "Version 1.2 (October 01, 2013)"
      extends Modelica.Icons.ReleaseNotes;

      annotation (Documentation(info="<html>
<ul>
<li>Adapted to the conventions of the Modelica Standard Library 3.2.1 and Modelica_Synchronous 0.92.</li>
<li>Utility functions to load parameters from a file.</li>
</ul>
</html>"));
    end Version_1_2;

    class Version_1_1 "Version 1.1 (April 24, 2013)"
      extends Modelica.Icons.ReleaseNotes;

      annotation (Documentation(info="<html>
<ul>
<li>Improved Modelica 3.3 standard conformance (hopefully completely standard conform by now)</li>
<li>Included support for the <i>Linux Controller Area Network Protocol Family</i> (aka <a href=\"modelica://Modelica_DeviceDrivers.Blocks.Communication.SocketCAN\">Socket CAN</a>). This is considered an <i><b>alpha feature</b></i>. Therefore the API is not stable and testing has been very limited.</li>
<li>The CMake based build system for the external C sources of this library has been improved to be more robust and better documented.</li>
<li>Bugs in the SerialPackager&apos;s <code>AddString</code> and <code>GetString</code> blocks have been resolved and new blocks <code>AddFloat</code> and <code>GetFloat</code> are now available.</li>
<li>Some smaller additional bug fixes and improvements.</li>
</ul>
</html>"));
    end Version_1_1;

    class Version_1_0 "Version 1.0 (Sept. 20, 2012)"
      extends Modelica.Icons.ReleaseNotes;
      annotation (Documentation(info="<html>
<ul>
 <li>Improved documentation.</li>
 <li>Included prototypical support for Softing CAN interfaces</li>
</ul>

</html>"));
    end Version_1_0;

    class Version_0_9 "Version 0.9 (Aug. 28, 2012)"
      extends Modelica.Icons.ReleaseNotes;
      annotation (Documentation(info="<html>
<p>
First public version of the library.
</p>

</html>"));
    end Version_0_9;

    annotation (Documentation(info="<html>
<p>
This section summarizes the changes that have been performed
on the Modelica_DeviceDrivers library.
</p>

</html>"));
  end ReleaseNotes;

  class Contact "Contact"
    extends Modelica.Icons.Contact;
    annotation (Documentation(info="<html>
<dl>
<dt><b>Main Authors:</b></dt>
<dd>Bernhard Thiele (main contact, release management, etc.)<br>
    at <a href=\"https://github.com/bernhard-thiele\">GitHub</a><br></dd>
<dd>Tobias Bellmann<br>
    at <a href=\"https://github.com/tbellmann\">GitHub</a><br></dd>
<dd>Thomas Beutlich<br>
    at <a href=\"https://github.com/beutlich\">GitHub</a><br></dd>
</dl>
<p>
The authors are open to include contributions.
</p>
<p> Please note that you can use the <b>issue tracker</b> provided by GitHub to report bugs or other issues (<a href=\"https://github.com/modelica/Modelica_DeviceDrivers/issues\">https://github.com/modelica/Modelica_DeviceDrivers/issues</a>)</p>

<p>
The following people have directly contributed to the implementation
of the library:
</p>

<table border=1 cellspacing=0 cellpadding=2>

<tr><td valign=\"top\"><b>Miguel Neves</b> </td>
   <td valign=\"top\">&nbsp;</td>
   <td valign=\"top\">Human readable error codes for the Softing CAN interface.</td>
</tr>
<tr><td valign=\"top\"><b>Dominik Sommer</b> </td>
   <td valign=\"top\">&nbsp;</td>
   <td valign=\"top\">Blocks.Communication.SerialPortReceive<br>
                    Blocks.Communication.SerialPortSend<br>
                    Communication.SerialPort<br>
                    Communication.SerialPort_</td>
</tr>
<tr><td valign=\"top\"><b>Rangarajan Varadan</b> </td>
   <td valign=\"top\">at <a href=\"http://www.codeproject.com/Members/Rangarajan-Varadan\">CodeProject</a></td>
   <td valign=\"top\">Code for Windows serial port support.</td>
</tr>
<tr><td valign=\"top\"><b>Dietmar Winkler</b> </td>
   <td valign=\"top\">at <a href=\"https://github.com/dietmarw\">Github</a></td>
   <td valign=\"top\">GitHub project setup, development services integration etc.</td>
</tr>
</table>
</html>"));
  end Contact;

  annotation (DocumentationClass=true, Documentation(info="<html>
<p>
Library <b>Modelica_DeviceDrivers</b> is a Modelica package
that interfaces hardware drivers. This package contains the <b>user's guide</b> for
the library and has the following content:
</p>
<ol>
<li><a href=\"modelica://Modelica_DeviceDrivers.UsersGuide.GettingStarted\">Getting started</a>
    contains an introduction to the most important features and how
    to use them at hand of examples.</li>
<li><a href=\"modelica://Modelica_DeviceDrivers.UsersGuide.Requirements\">Requirements</a>
    sketches the requirements on a Modelica tool, in order that this library
    can be utilized.</li>
<li><a href=\"modelica://Modelica_DeviceDrivers.UsersGuide.References\">References</a>
    provides references that have been used to design and implement this
    library.</li>
<li><a href=\"modelica://Modelica_DeviceDrivers.UsersGuide.ReleaseNotes\">Release Notes</a>
    summarizes the differences between different versions of this library.</li>
<li><a href=\"modelica://Modelica_DeviceDrivers.UsersGuide.Contact\">Contact</a>
    provides information about the authors of the library as well as
    acknowledgments.</li>
</ol>


</html>"));
end UsersGuide;
