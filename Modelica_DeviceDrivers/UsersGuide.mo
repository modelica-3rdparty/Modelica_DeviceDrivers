within Modelica_DeviceDrivers;
package UsersGuide "User's Guide"
  package ReleaseNotes "Release notes"
    extends Modelica.Icons.ReleaseNotes;
    class Version_2_1_0 "Version 2.1.0 (August 10, 2022)"
    extends Modelica.Icons.ReleaseNotes;

      annotation (Documentation(info="<html>
<p>Enhancements:</p>
<ul>
<li>Added parameter <code>useRecvThread</code> also for <em>clocked</em> <code>UDPReceive</code> variant (<a href=\"https://github.com/modelica-3rdparty/Modelica_DeviceDrivers/issues/342\">#342</a>).</li>
<li>Added option for not unlinking shared memory partition at process termination (<a href=\"https://github.com/modelica-3rdparty/Modelica_DeviceDrivers/issues/339\">#339</a>).</li>
<li>Updated 3rd-party library paho.mqtt.c to v1.3.10 (<a href=\"https://github.com/modelica-3rdparty/Modelica_DeviceDrivers/pull/355\">#355</a>).</li>
</ul>
<p>Bug fixes:</p>
<ul>
<li>Fixed <code>RealtimeSynchronize</code> block &quot;clock_nanosleep&quot; error on Linux (<a href=\"https://github.com/modelica-3rdparty/Modelica_DeviceDrivers/issues/357\">#357</a>).</li>
<li>Fixed <code>MDD_TCPIPServer_Send(...)</code> return value, so that it works as described in the documentation &quot;On success, return the number of bytes sent, 0 if operation would block, -1 on non-fatal error&quot; (<a href=\"https://github.com/modelica-3rdparty/Modelica_DeviceDrivers/issues/323\">#323</a>).</li>
<li>Serial port interface on Windows: Fixed spurious byte sent at the end of a simulation (<a href=\"https://github.com/modelica-3rdparty/Modelica_DeviceDrivers/issues/352\">#352</a>).</li>
</ul>
<p>Other (minor) fixes and improvements.</p>
</html>"));
    end Version_2_1_0;

    class Version_2_0_0 "Version 2.0.0 (June 8, 2020)"
    extends Modelica.Icons.ReleaseNotes;

      annotation (Documentation(info="<html>
<p>Migrated from Modelica Standard Library 3 (MSL 3) to MSL 4 &#8594; Non-backwards compatible release!</p>
<p>However, apart from the MSL 4 dependency this release is compatible to previous releases and no update of user libraries is necessary apart from migrating to MSL 4.</p>
<p>Enhancements:</p>
<ul>
<li>Added all license files to better assist tool vendors in distribution of source or binary files (<a href=\"https://github.com/modelica-3rdparty/Modelica_DeviceDrivers/pull/313\">#313</a>).</li>
<li>Updated 3rd-party library paho.mqtt.c to v1.3.4 (<a href=\"https://github.com/modelica-3rdparty/Modelica_DeviceDrivers/pull/320\">#320</a>).</li>
</ul>
<p>Bug fixes:</p>
<ul>
<li>Fixed small issues in the SBHS Board example (<a href=\"https://github.com/modelica-3rdparty/Modelica_DeviceDrivers/pull/318\">#318</a>).</li>
</ul>
<p>Other (minor) fixes and improvements.</p>
</html>"));
    end Version_2_0_0;

    class Version_1_8_2 "Version 1.8.2 (March 26, 2020)"
    extends Modelica.Icons.ReleaseNotes;

      annotation (Documentation(info="<html>
<ul>
<li>
Updated Linux MQTT binary dependencies. The updated libraries are compiled with
the <code>-fPIC</code> flag, which fixes a related FMU generation problem
(<a href=\"https://github.com/modelica-3rdparty/Modelica_DeviceDrivers/issues/306\">#306</a>).
</li>
</ul>
</html>"));
    end Version_1_8_2;

    class Version_1_8_1 "Version 1.8.1 (February 26, 2020)"
    extends Modelica.Icons.ReleaseNotes;

      annotation (Documentation(info="<html>
<ul>
<li>
Fix declaration of <code>MDD_spaceMouseGetData</code> in external C code (<a href=\"https://github.com/modelica-3rdparty/Modelica_DeviceDrivers/issues/305\">#305</a>)
</li>
</ul>
</html>"));
    end Version_1_8_1;

    class Version_1_8_0 "Version 1.8.0 (January 11, 2020)"
    extends Modelica.Icons.ReleaseNotes;

      annotation (Documentation(info="<html>
<p>Enhancements:</p>
<ul>
<li>TCP/IP server communication (<a href=\"https://github.com/modelica-3rdparty/Modelica_DeviceDrivers/pull/296\">#296</a>). In addition to the existing TCP/IP client blocks (see <a href=\"https://github.com/modelica-3rdparty/Modelica_DeviceDrivers/issues/78\">#78</a>) there are now also blocks for setting up a TCP/IP server. See examples <span style=\"font-family: monospace;\">Blocks.Examples.TestSerialPackager_TCPIPServer</span> and <span style=\"font-family: monospace;\">Blocks.Examples.TestSerialPackager_TCPIPServerMultipleClients</span>.</li>
<li>Enhanced real-time synchronization block (<a href=\"https://github.com/modelica-3rdparty/Modelica_DeviceDrivers/issues/290\">#290</a>). Added an enhanced real-time synchronization block<br>(<span style=\"font-family: monospace;\">Blocks.OperatingSystem.RealtimeSynchronize</span>) and deprecated the existing block (<span style=\"font-family: monospace;\">Blocks.OperatingSystem.SynchronizeRealtime</span>). The deprecated block is known to not working well with recent Dymola versions (e.g., Dymola 2020). The new <span style=\"font-family: monospace;\">RealtimeSynchronize</span> block supports a sample-based real-time synchronization mode which is recommended for more deterministic, less solver sensitive behavior. See example <span style=\"font-family: monospace;\">Blocks.Examples.TestRealtimeSynchronize</span>.</li>
<li>An utility block for debugging purposes which prints a message when triggered by an event (<a href=\"https://github.com/modelica-3rdparty/Modelica_DeviceDrivers/issues/289\">#289</a>).</li>
<li>Update 3rd-party library paho.mqtt.c to v1.3.1 (<a href=\"https://github.com/modelica-3rdparty/Modelica_DeviceDrivers/pull/293\">#293</a>)</li>
</ul>
<p>Bug fixes:</p>
<ul>
<li>Fixed Spacemouse not working under Windows 10 bug (<a href=\"https://github.com/modelica-3rdparty/Modelica_DeviceDrivers/issues/289\">#289</a>).</li>
<li>More similar behavior for getMACAddress() in Windows and Linux (<a href=\"https://github.com/modelica-3rdparty/Modelica_DeviceDrivers/issues/263\">#263</a>). </li>
</ul>
<p>Other (minor) fixes and improvements.</p>
</html>"));
    end Version_1_8_0;

    class Version_1_7_0 "Version 1.7.0 (March 28, 2019)"
    extends Modelica.Icons.ReleaseNotes;

      annotation (Documentation(info="<html>
<p>Enhancements:</p>
<ul>
<li>Uses latest version of Modelica Standard Library (v3.2.3).</li>
<li>Option for using blocking UDP receive calls (<a href=\"https://github.com/modelica-3rdparty/Modelica_DeviceDrivers/pull/275\">#275</a>). On the function interface level an optional third argument in the <a href=\"modelica://Modelica_DeviceDrivers.Communication.UDPSocket.constructor\">UDPSocket constructor</a> allows to create the external object without starting a dedicated receive thread (default: <span style=\"font-family: Courier New;\">useRecvThread=true</span>). On the block interface level (block <a href=\"modelica://Modelica_DeviceDrivers.Blocks.Communication.UDPReceive\">UDPReceive</a>) a new parameter <span style=\"font-family: Courier New;\">useRecvThread</span> (default: <span style=\"font-family: Courier New;\">useRecvThread=true</span>) allows to select the desired behavior. See example <a href=\"modelica://Modelica_DeviceDrivers.Blocks.Examples.TestSerialPackager_UDPWithoutReceiveThread\">TestSerialPackager_UDPWithoutReceiveThread</a>.</li>
<li>Added parameter <code>enable</code> (default: <code>enable=true</code>) for conditionally enabling or disabling the real-time synchronization within the <a href=\"modelica://Modelica_DeviceDrivers.Blocks.OperatingSystem.SynchronizeRealtime\">SynchronizeRealtime</a> block (<a href=\"https://github.com/modelica-3rdparty/Modelica_DeviceDrivers/issues/270\">#270</a>).</li>
<li>Update OpenSSL to 1.0.2r (<a href=\"https://github.com/modelica-3rdparty/Modelica_DeviceDrivers/pull/280\">#280</a>).</li>
</ul>
<p>Bug fixes:</p>
<ul>
<li>EmbeddedTargets.AVR: Only start the RT synch timer once (<a href=\"https://github.com/modelica-3rdparty/Modelica_DeviceDrivers/pull/274\">#274</a>).</li>
<li>EmbeddedTargets.AVR: Fixed reading of digital pins (<a href=\"https://github.com/modelica-3rdparty/Modelica_DeviceDrivers/pull/266\">#266</a>).</li>
<li>Fixed Cygwin build (<a href=\"https://github.com/modelica-3rdparty/Modelica_DeviceDrivers/pull/271\">#271</a>). </li>
<li>Fixed scale factor calculation error in <code>JoystickInput</code> block (<a href=\"https://github.com/modelica-3rdparty/Modelica_DeviceDrivers/pull/272\">#272</a>).</li>
<li>Fix missing byte copy of &apos;\\0&apos; in external C code function <code>MDDEXT_SerialPackagerGetString()</code> (<a href=\"https://github.com/modelica-3rdparty/Modelica_DeviceDrivers/pull/273\">#273</a>).</li>
</ul>
<p>Other (minor) fixes and improvements.</p>
</html>"));
    end Version_1_7_0;

    class Version_1_6_0 "Version 1.6.0 (October 6, 2018)"
    extends Modelica.Icons.ReleaseNotes;

      annotation (Documentation(info="<html>
<ul>
<li>Support for MQTT (Message Queuing Telemetry Transport protocol) client communication (<a href=\"https://github.com/modelica-3rdparty/Modelica_DeviceDrivers/issues/130\">#130</a>, <a href=\"https://github.com/modelica-3rdparty/Modelica_DeviceDrivers/issues/256\">#256</a>).
See example <a href=\"modelica://Modelica_DeviceDrivers.Blocks.Examples.TestSerialPackager_MQTT\">TestSerialPackager_MQTT</a>.
</li>
<li>
Utility function to retrieve MAC address (<a href=\"modelica://Modelica_DeviceDrivers.Utilities.Functions.getMACAddress\">getMACAddress</a>, <a href=\"https://github.com/modelica-3rdparty/Modelica_DeviceDrivers/issues/255\">#255</a>).
</li>
<li>
Utility function to generate a UUID (<a href=\"modelica://Modelica_DeviceDrivers.Utilities.Functions.generateUUID\">generateUUID</a>, <a href=\"https://github.com/modelica-3rdparty/Modelica_DeviceDrivers/issues/244\">#244</a>).
</li>
<li>
Number of received bytes in `UDPReceive` block are provided as outputs (<a href=\"https://github.com/modelica-3rdparty/Modelica_DeviceDrivers/issues/236\">#236</a>).
</li>
<li>
Scalable real-time synchronization (<a href=\"https://github.com/modelica-3rdparty/Modelica_DeviceDrivers/issues/215\">#215</a>).
</li>
<li>
Adaption of the new Modelica Association license: <b>BSD-3 clause</b>
(<a href=\"https://github.com/modelica-3rdparty/Modelica_DeviceDrivers/issues/238\">#238</a>, <a href=\"https://github.com/modelica-3rdparty/Modelica_DeviceDrivers/issues/264\">#254</a>).
The C-code parts of the library were already BSD 3-Clause licensed, but the Modelica code
was licensed under the Modelica License 2. Since Modelica Association projects,
most notably the Modelica Standard Library (MSL), changed from Modelica License 2 to
the BSD 3-Clause license, the Modelica_DeviceDrivers library follows this development.
</li>
<li>
Other (minor) fixes and improvements.
</li>
</ul>
</html>"));
    end Version_1_6_0;

    class Version_1_5_1 "Version 1.5.1 (September 19, 2017)"
    extends Modelica.Icons.ReleaseNotes;

      annotation (Documentation(info=
                                 "<html>
<ul>
<li>
Bug fix for variable name spelling error in <code>Blocks.InputDevices.JoystickInput</code> (<a href=\"https://github.com/modelica-3rdparty/Modelica_DeviceDrivers/issues/224\">#224</a>)
</li>
</ul>
</html>"));
    end Version_1_5_1;

    class Version_1_5_0 "Version 1.5.0 (May 12, 2017)"
    extends Modelica.Icons.ReleaseNotes;

      annotation (Documentation(info=
                                 "<html>
<ul>
<li>
<b>Important:</b> A bug fix in the shared memory implementation for <i>Windows</i>
potentially affects applications that adapted the (wrong) buffer layout
(see PR <a href=\"https://github.com/modelica-3rdparty/Modelica_DeviceDrivers/pull/138\">#138</a>)!
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
Bug fix for the byte order swapping logic (endianness, <a href=\"https://github.com/modelica-3rdparty/Modelica_DeviceDrivers/issues/203\">#203</a>).
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
<li>Changed license of external C code and header files to Simplified BSD License. (The Modelica package parts remain under Modelica License 2.)</li>
<li>Improved Modelica compatibility: Fixed the use of conditionally enabled variable <code>procPrio</code> outside of connect in <code>Blocks.OperatingSystem.SynchronizeRealtime</code> and <code>ClockedBlocks.OperatingSystem.SynchronizeRealtime</code>.</li>
<li>Improved Modelica compatibility: Fixed the invalid integer to enumeration type conversion in <code>HardwareIO</code>.</li>
<li>Fully specified the initial conditions for example models.</li>
<li>Simplified the linking with system libraries (MSVC only).</li>
<li>Added continuous integration for the external C code (thanks to <a href=\"https://travis-ci.org/modelica-3rdparty/Modelica_DeviceDrivers\">Travis CI</a>).</li>
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
<p>For the (optional) use of the blocks provided in
<a href=\"modelica://Modelica_DeviceDrivers.ClockedBlocks\">ClockedBlocks</a> the
tool needs support for the Modelica 3.3 language elements of Chapter 16
\"Synchronous Language Elements\" of the Modelica Language Specification 3.3.
Please notice that except for the underlying activation mechanism, the realized functionality is similar as the one provided by
<a href=\"modelica://Modelica_DeviceDrivers.Blocks\">Blocks</a>.
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
Technical details of this library are described in the paper:
</p>
<dl>
<dt>Bernhard Thiele, Thomas Beutlich, Volker Waurich, Martin Sj&ouml;lund, and Tobias Bellmann.</dt>
<dd> <strong>Towards a Standard-Conform, Platform-Generic and Feature-Rich Modelica Device Drivers Library</strong>.
     In Jiř&iacute; Kofr&aacute;nek and Francesco Casella, editors,
     12th Int. Modelica Conference, Prague, Czech Republic, May 2017.
     <a href=\"https://www.modelica.org/events/modelica2017/proceedings/html/submissions/ecp17132713_ThieleBeutlichWaurichSjolundBellmann.pdf\">Download</a>.
</dd>
</dl>

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

  class Contact "Contact"
    extends Modelica.Icons.Contact;
    annotation (Documentation(info="<html>
<dl>
<dt><b>Main Authors:</b></dt>
<dd>Bernhard Thiele (main contact, release management, etc.)<br>
    at <a href=\"https://github.com/bernhard-thiele\">GitHub</a><br></dd>
<dd>Thomas Beutlich<br>
    at <a href=\"https://github.com/beutlich\">GitHub</a><br></dd>
<dd>Tobias Bellmann<br>
    at <a href=\"https://github.com/tbellmann\">GitHub</a><br></dd>
</dl>

<p>
The authors are open to include contributions.
</p>

<p>
Please note that you can use the <b>issue tracker</b> provided by GitHub to report bugs or other issues (<a href=\"https://github.com/modelica-3rdparty/Modelica_DeviceDrivers/issues\">https://github.com/modelica-3rdparty/Modelica_DeviceDrivers/issues</a>)
</p>

<p>
The following people have directly contributed to the implementation
of the library (many more have contributed by providing feedback and suggestions):
</p>

<table border=\"1\" cellspacing=\"0\" cellpadding=\"2\">

<tr><td valign=\"top\"><b>Miguel Neves</b> </td>
   <td valign=\"top\">at <a href=\"https://github.com/ChukasNeves\">GitHub</a></td>
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
   <td valign=\"top\">at <a href=\"https://github.com/dietmarw\">GitHub</a></td>
   <td valign=\"top\">GitHub project setup, development services integration etc.</td>
</tr>
<tr><td valign=\"top\"><b>Martin Sj&ouml;lund</b> </td>
   <td valign=\"top\">at <a href=\"https://github.com/sjoelund\">GitHub</a></td>
   <td valign=\"top\"><code>EmbeddedTargets.AVR</code> support.</td>
</tr>
<tr><td valign=\"top\"><b>Lutz Berger</b> </td>
   <td valign=\"top\">at <a href=\"https://github.com/it-cosmos\">GitHub</a></td>
   <td valign=\"top\"><code>EmbeddedTargets.STM32F4</code> (experimental) support.</td>
</tr>
</table>
<p>
Several more contributed bug fix PRs etc.
</p>
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
