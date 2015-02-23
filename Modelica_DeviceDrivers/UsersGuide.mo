within Modelica_DeviceDrivers;
package UsersGuide "User's Guide"
    extends Modelica.Icons.Information;

  class GettingStarted "Getting started"
      extends Modelica.Icons.Information;

    annotation (Documentation(info="<html>
<p>In this section, a first introduction to the Modelica_DeviceDrivers library is given at hand of several examples.</p>
<h4><font color=\"#008000\">Introduction</font></h4>
<p>The library allows to access some selected external devices in Modelica models. This is achieved by using the Modelica external C interface to call the appropriate C driver functions provided by the underlying operating system. Currently MS Windows and Linux are supported.</p>
<p>The library is organized in several layers as indicated below. It is noteworthy that the library provides two high-level Drag &amp; Drop block interfaces. The first (.Blocks) is compatible to Modelica 3.2, using the traditional &quot;when sample()&quot; element for periodically calling Modelica functions from the Function Layer. The second (.ClockedBlocks) uses the<i> Synchronous Language Elements</i> extension introduced in Modelica 3.3 for periodic execution.</p>
<p><img src=\"modelica://Modelica_DeviceDrivers/Resources/Images/DeviceDrivers_LayeredArchitecture.png\"/></p>
<h4><font color=\"#008000\">Usage Examples</font></h4>
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
<p>
The library was tested with Dymola 2013 and a prototype of Dymola supporting the \"Synchrchronous Language Elements\" (see above).
The library is known to work only partly with Dymola 2012FD0, due to a bug in handling external objects in that Dymola version.
</p>
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
    class Version_0_9 "Version 0.9 (Aug. 28, 2012)"
      extends Modelica.Icons.ReleaseNotes;
      annotation (Documentation(info="<html>
<p>
First public version of the library.
</p>

</html>"));
    end Version_0_9;

    class Version_1_0 "Version 1.0 (Sept. 20, 2012)"
      extends Modelica.Icons.ReleaseNotes;
      annotation (Documentation(info="<html>
<ul>
 <li>Improved documentation.</li>
 <li>Included prototypical support for Softing CAN interfaces</li>
</ul>

</html>"));
    end Version_1_0;

    class Version_1_1 "Version 1.1 (April 24, 2013)"
      extends Modelica.Icons.ReleaseNotes;

      annotation (Documentation(info="<html>
<ul>
<li>Improved Modelica 3.3 standard conformance (hopefully completely standard conform by now)</li>
<li>Included support for the <i>Linux Controller Area Network Protocol Family</i> (aka <a href=\"modelica://Modelica_DeviceDrivers.Blocks.Communication.SocketCAN\">Socket CAN</a>). This is considered an <i><b>alpha feature</b></i>. Therefore the API is not stable and testing has been very limited.</li>
<li>The cmake based build system for the external C sources of this library has been improved to be more robust and better documented.</li>
<li>Bugs in the SerialPackager&apos;s <code>AddString</code> and <code>GetString</code> blocks have been resolved and new blocks <code>AddFloat</code> and <code>GetFloat</code> are now available.</li>
<li>Some smaller additional bugfixes and improvements.</li>
</ul>
</html>"));
    end Version_1_1;

    class Version_1_2 "Version 1.2 (October 01, 2013)"
      extends Modelica.Icons.ReleaseNotes;

      annotation (Documentation(info="<html>
<ul>
<li>Adapted to the conventions of the Modelica Standard Library 3.2.1 and Modelica_Synchronous 0.92.</li>
<li>Utility functions to load parameters from a file.</li>
</ul>
</html>"));
    end Version_1_2;

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
    annotation (Documentation(info="<html>
<p>
This section summarizes the changes that have been performed
on the Modelica_Synchronous library.
</p>

</html>"));
  end ReleaseNotes;

class ModelicaLicense2 "Modelica License 2"
  extends Modelica.Icons.Information;
  annotation (Documentation(info="<html>
<head>
        <title>The Modelica License 2</title>
<style type=\"text/css\">
*       { font-size: 10pt; font-family: Arial,sans-serif; }
code    { font-size:  9pt; font-family: Courier,monospace;}
h6      { font-size: 10pt; font-weight: bold; color: green; }
h5      { font-size: 11pt; font-weight: bold; color: green; }
h4      { font-size: 13pt; font-weight: bold; color: green; }
address {                  font-weight: normal}
td      { solid #000; vertical-align:top; }
th      { solid #000; vertical-align:top; font-weight: bold; }
table   { solid #000; border-collapse: collapse;}
</style>
</head>
<body lang=\"en-US\">

<p>All files in this directory (\"<i>Modelica_DeviceDrivers</i>\") and in all
subdirectories, <b>except</b> for the contents of the directories
\"<i>Modelica_DeviceDrivers/Resources/Library</i>\", and \"<i>Modelica_DeviceDrivers/Resources/thirdParty</i>\",
are licensed by <b>DLR</b> under the
<b>Modelica License 2</b>.</p>

<p style=\"margin-left: 40px;\"><b>Licensor:</b><br>
German Aerospace Center (DLR)<br>
Robotics and Mechatronics Center<br>
Institute of System Dynamics and Control<br>
Postfach 1116<br>
D-82230 Wessling<br>
Germany<br>
email: Martin.Otter@dlr.de
</p>

<p style=\"margin-left: 40px;\"><b>Copyright notices of the files:</b><br>
Copyright &copy; 2012, DLR Institute of System Dynamics and Control.<br>
<br>
</p>

<p>
<a href=\"#The_Modelica_License_2-outline\">The Modelica License 2</a><br>
<a href=\"#How_to_Apply_the_Modelica_License_2-outline\">How to Apply the Modelica License 2</a><br>
<a href=\"#Frequently_Asked_Questions-outline\">Frequently Asked Questions</a><br>
</p>

<hr>

<h4><a name=\"The_Modelica_License_2-outline\"></a>The Modelica License 2</h4>

<p>
<b>Preamble.</b> The goal of this license is that Modelica related
model libraries, software, images, documents, data files etc. can be
used freely in the original or a modified form, in open source and in
commercial environments (as long as the license conditions below are
fulfilled, in particular sections 2c) and 2d). The Original Work is
provided free of charge and the use is completely at your own risk.
Developers of free Modelica packages are encouraged to utilize this
license for their work.</p>

<p>
The Modelica License applies to any Original Work that contains the
following licensing notice adjacent to the copyright notice(s) for
this Original Work:</p>

<p><b>Licensed by DLR under the Modelica License 2</b></p>

<p><b>1. Definitions.</b></p>
<ol type=\"a\">
        <li>&ldquo;License&rdquo; is this Modelica License.</li>

        <li>&ldquo;Original Work&rdquo; is any work of authorship, including
        software, images, documents, data files, that contains the above
        licensing notice or that is packed together with a licensing notice
        referencing it.</li>

        <li>&ldquo;Licensor&rdquo; is the provider of the Original Work who has
        placed this licensing notice adjacent to the copyright notice(s) for
        the Original Work. The Original Work is either directly provided by
        the owner of the Original Work, or by a licensee of the owner.</li>

        <li>&ldquo;Derivative Work&rdquo; is any modification of the Original
        Work which represents, as a whole, an original work of authorship.
        For the matter of clarity and as examples:

        <ol  type=\"A\">
                <li>Derivative Work shall not include work that remains separable from
                the Original Work, as well as merely extracting a part of the
                Original Work without modifying it.</li>

                <li>Derivative Work shall not include (a) fixing of errors and/or (b)
                adding vendor specific Modelica annotations and/or (c) using a
                subset of the classes of a Modelica package, and/or (d) using a
                different representation, e.g., a binary representation.</li>

                <li>Derivative Work shall include classes that are copied from the
                Original Work where declarations, equations or the documentation
                are modified.</li>

                <li>Derivative Work shall include executables to simulate the models
                that are generated by a Modelica translator based on the Original
                Work (of a Modelica package).</li>
        </ol>

        <li>&ldquo;Modified Work&rdquo; is any modification of the Original Work
        with the following exceptions: (a) fixing of errors and/or (b)
        adding vendor specific Modelica annotations and/or (c) using a
        subset of the classes of a Modelica package, and/or (d) using a
        different representation, e.g., a binary representation.</li>

        <li>&quot;Source Code&quot; means the preferred form of the Original
        Work for making modifications to it and all available documentation
        describing how to modify the Original Work.</li>

        <li>&ldquo;You&rdquo; means an individual or a legal entity exercising
        rights under, and complying with all of the terms of, this License.</li>

        <li>&ldquo;Modelica package&rdquo; means any Modelica library that is
        defined with the &ldquo;<code><b>package</b>&nbsp;&lt;Name&gt;&nbsp;...&nbsp;<b>end</b>&nbsp;&lt;Name&gt;;</code>&rdquo; Modelica language element.</li>

</ol>

<p>
<b>2. Grant of Copyright License.</b> Licensor grants You a
worldwide, royalty-free, non-exclusive, sublicensable license, for
the duration of the copyright, to do the following:</p>

<ol type=\"a\">
        <li><p>
        To reproduce the Original Work in copies, either alone or as part of
        a collection.</p></li>
        <li><p>
        To create Derivative Works according to Section 1d) of this License.</p></li>
        <li><p>
        To distribute or communicate to the public copies of the <u>Original
        Work</u> or a <u>Derivative Work</u> under <u>this License</u>. No
        fee, neither as a copyright-license fee, nor as a selling fee for
        the copy as such may be charged under this License. Furthermore, a
        verbatim copy of this License must be included in any copy of the
        Original Work or a Derivative Work under this License.<br>
        For the matter of clarity, it is permitted A) to distribute or
        communicate such copies as part of a (possible commercial)
        collection where other parts are provided under different licenses
        and a license fee is charged for the other parts only and B) to
        charge for mere printing and shipping costs.</p></li>
        <li><p>
        To distribute or communicate to the public copies of a <u>Derivative
        Work</u>, alternatively to Section 2c), under <u>any other license</u>
        of your choice, especially also under a license for
        commercial/proprietary software, as long as You comply with Sections
        3, 4 and 8 below. <br>      For the matter of clarity, no
        restrictions regarding fees, either as to a copyright-license fee or
        as to a selling fee for the copy as such apply.</p></li>
        <li><p>
        To perform the Original Work publicly.</p></li>
        <li><p>
        To display the Original Work publicly.</p></li>
</ol>

<p>
<b>3. Acceptance.</b> Any use of the Original Work or a
Derivative Work, or any action according to either Section 2a) to 2f)
above constitutes Your acceptance of this License.</p>

<p>
<b>4. Designation of Derivative Works and of Modified Works.
</b>The identifying designation of Derivative Work and of Modified
Work must be different to the corresponding identifying designation
of the Original Work. This means especially that the (root-level)
name of a Modelica package under this license must be changed if the
package is modified (besides fixing of errors, adding vendor specific
Modelica annotations, using a subset of the classes of a Modelica
package, or using another representation, e.g. a binary
representation).</p>

<p>
<b>5. Grant of Patent License.</b>
Licensor grants You a worldwide, royalty-free, non-exclusive, sublicensable license,
under patent claims owned by the Licensor or licensed to the Licensor by
the owners of the Original Work that are embodied in the Original Work
as furnished by the Licensor, for the duration of the patents,
to make, use, sell, offer for sale, have made, and import the Original Work
and Derivative Works under the conditions as given in Section 2.
For the matter of clarity, the license regarding Derivative Works covers
patent claims to the extent as they are embodied in the Original Work only.</p>

<p>
<b>6. Provision of Source Code.</b> Licensor agrees to provide
You with a copy of the Source Code of the Original Work but reserves
the right to decide freely on the manner of how the Original Work is
provided.<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;For the matter of clarity, Licensor might provide only a binary
representation of the Original Work. In that case, You may (a) either
reproduce the Source Code from the binary representation if this is
possible (e.g., by performing a copy of an encrypted Modelica
package, if encryption allows the copy operation) or (b) request the
Source Code from the Licensor who will provide it to You.</p>

<p>
<b>7. Exclusions from License Grant.</b> Neither the names of
Licensor, nor the names of any contributors to the Original Work, nor
any of their trademarks or service marks, may be used to endorse or
promote products derived from this Original Work without express
prior permission of the Licensor. Except as otherwise expressly
stated in this License and in particular in Sections 2 and 5, nothing
in this License grants any license to Licensor&rsquo;s trademarks,
copyrights, patents, trade secrets or any other intellectual
property, and no patent license is granted to make, use, sell, offer
for sale, have made, or import embodiments of any patent claims.<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;No license is granted to the trademarks of
Licensor even if such trademarks are included in the Original Work,
except as expressly stated in this License. Nothing in this License
shall be interpreted to prohibit Licensor from licensing under terms
different from this License any Original Work that Licensor otherwise
would have a right to license.</p>

<p>
<b>8. Attribution Rights.</b> You must retain in the Source
Code of the Original Work and of any Derivative Works that You
create, all author, copyright, patent, or trademark notices, as well
as any descriptive text identified therein as an &quot;Attribution
Notice&quot;. The same applies to the licensing notice of this
License in the Original Work. For the matter of clarity, &ldquo;author
notice&rdquo; means the notice that identifies the original
author(s). <br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;You must cause the Source Code for any Derivative
Works that You create to carry a prominent Attribution Notice
reasonably calculated to inform recipients that You have modified the
Original Work. <br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;In case the Original Work or Derivative Work is not provided in
Source Code, the Attribution Notices shall be appropriately
displayed, e.g., in the documentation of the Derivative Work.</p>

<p><b>9. Disclaimer
of Warranty. <br></b><u><b>The Original Work is provided under this
License on an &quot;as is&quot; basis and without warranty, either
express or implied, including, without limitation, the warranties of
non-infringement, merchantability or fitness for a particular
purpose. The entire risk as to the quality of the Original Work is
with You.</b></u> This disclaimer of warranty constitutes an
essential part of this License. No license to the Original Work is
granted by this License except under this disclaimer.</p>

<p>
<b>10. Limitation of Liability.</b> Under no circumstances and
under no legal theory, whether in tort (including negligence),
contract, or otherwise, shall the Licensor, the owner or a licensee
of the Original Work be liable to anyone for any direct, indirect,
general, special, incidental, or consequential damages of any
character arising as a result of this License or the use of the
Original Work including, without limitation, damages for loss of
goodwill, work stoppage, computer failure or malfunction, or any and
all other commercial damages or losses. This limitation of liability
shall not apply to the extent applicable law prohibits such
limitation.</p>

<p>
<b>11. Termination.</b> This License conditions your rights to
undertake the activities listed in Section 2 and 5, including your
right to create Derivative Works based upon the Original Work, and
doing so without observing these terms and conditions is prohibited
by copyright law and international treaty. Nothing in this License is
intended to affect copyright exceptions and limitations. This License
shall terminate immediately and You may no longer exercise any of the
rights granted to You by this License upon your failure to observe
the conditions of this license.</p>

<p>
<b>12. Termination for Patent Action.</b> This License shall
terminate automatically and You may no longer exercise any of the
rights granted to You by this License as of the date You commence an
action, including a cross-claim or counterclaim, against Licensor,
any owners of the Original Work or any licensee alleging that the
Original Work infringes a patent. This termination provision shall
not apply for an action alleging patent infringement through
combinations of the Original Work under combination with other
software or hardware.</p>

<p>
<b>13. Jurisdiction.</b> Any action or suit relating to this
License may be brought only in the courts of a jurisdiction wherein
the Licensor resides and under the laws of that jurisdiction
excluding its conflict-of-law provisions. The application of the
United Nations Convention on Contracts for the International Sale of
Goods is expressly excluded. Any use of the Original Work outside the
scope of this License or after its termination shall be subject to
the requirements and penalties of copyright or patent law in the
appropriate jurisdiction. This section shall survive the termination
of this License.</p>

<p>
<b>14. Attorneys&rsquo; Fees.</b> In any action to enforce the
terms of this License or seeking damages relating thereto, the
prevailing party shall be entitled to recover its costs and expenses,
including, without limitation, reasonable attorneys' fees and costs
incurred in connection with such action, including any appeal of such
action. This section shall survive the termination of this License.</p>

<p>
<b>15. Miscellaneous.</b>
</p>
<ol type=\"a\">
        <li>If any
        provision of this License is held to be unenforceable, such
        provision shall be reformed only to the extent necessary to make it
        enforceable.</li>

        <li>No verbal
        ancillary agreements have been made. Changes and additions to this
        License must appear in writing to be valid. This also applies to
        changing the clause pertaining to written form.</li>

        <li>You may use the
        Original Work in all ways not otherwise restricted or conditioned by
        this License or by law, and Licensor promises not to interfere with
        or be responsible for such uses by You.</li>
</ol>

<hr>

<h4><a name=\"How_to_Apply_the_Modelica_License_2-outline\"></a>
How to Apply the Modelica License 2</h4>

<p>At
the top level of your Modelica package and at every important
subpackage, add the following notices in the info layer of the
package:</p>

<p>
Licensed by &lt;Licensor&gt; under the Modelica License 2<br>
Copyright &copy; &lt;year1&gt;-&lt;year2&gt;, &lt;name of copyright
holder(s)&gt;.
</p>

<p>
<i>This Modelica package is <u>free</u> software and the use is completely at <u>your own risk</u>; it can be redistributed and/or modified under the terms of the Modelica License 2. For license conditions (including the disclaimer of warranty) see <a href=\"modelica://Modelica.UsersGuide.ModelicaLicense2\">Modelica.UsersGuide.ModelicaLicense2</a> or visit <a href=\"http://www.modelica.org/licenses/ModelicaLicense2\"> http://www.modelica.org/licenses/ModelicaLicense2</a>.</i>
</p>

<p>Include
a copy of the Modelica License 2 under
<b>&lt;library&gt;.UsersGuide.ModelicaLicense2</b>
(use <a href=\"http://www.modelica.org/licenses/ModelicaLicense2.mo\">
http://www.modelica.org/licenses/ModelicaLicense2.mo</a>).
Furthermore, add
the list of authors and contributors under
<b>&lt;library&gt;.UsersGuide.Contributors</b> or
<b>&lt;library&gt;.UsersGuide.Contact</b>.</p>

<p>For
example, sublibrary Modelica.Blocks of the Modelica Standard Library
may have the following notices:</p>

<p>
Licensed by Modelica Association under the Modelica License 2<br>
Copyright &copy; 1998-2008, Modelica Association.
</p>

<p>
<i>This Modelica package is <u>free</u> software and the use is completely at <u>your own risk</u>; it can be redistributed and/or modified under the terms of the Modelica License 2. For license conditions (including the disclaimer of warranty) see <a href=\"modelica://Modelica.UsersGuide.ModelicaLicense2\">Modelica.UsersGuide.ModelicaLicense2</a> or visit <a href=\"http://www.modelica.org/licenses/ModelicaLicense2\"> http://www.modelica.org/licenses/ModelicaLicense2</a>.</i>
</p>

<p>For
C-source code and documents, add similar notices in the corresponding
file.</p>

<p>For
images, add a &ldquo;readme.txt&rdquo; file to the directories where
the images are stored and include a similar notice in this file.</p>

<p>In
these cases, save a copy of the Modelica License 2 in one directory
of the distribution, e.g.,
<a href=\"http://www.modelica.org/licenses/ModelicaLicense2.html\">
http://www.modelica.org/licenses/ModelicaLicense2.html</a>
in directory <b>&lt;library&gt;/Resources/Documentation/ModelicaLicense2.html</b>.
</p>

<hr>

<h5><a name=\"Frequently_Asked_Questions-outline\"></a>
Frequently Asked Questions</h5>
<p>This
section contains questions/answer to users and/or distributors of
Modelica packages and/or documents under Modelica License 2. Note,
the answers to the questions below are not a legal interpretation of
the Modelica License 2. In case of a conflict, the language of the
license shall prevail.</p>

<h6>Using or Distributing a Modelica <u>Package</u> under the Modelica License 2</h6>

<p><b>What are the main
differences to the previous version of the Modelica License?</b></p>
<ol>
        <li><p>
        Modelica License 1 is unclear whether the licensed Modelica package
        can be distributed under a different license. Version 2 explicitly
        allows that &ldquo;Derivative Work&rdquo; can be distributed under
        any license of Your choice, see examples in Section 1d) as to what
        qualifies as Derivative Work (so, version 2 is clearer).</p>
        <li><p>
        If You modify a Modelica package under Modelica License 2 (besides
        fixing of errors, adding vendor specific Modelica annotations, using
        a subset of the classes of a Modelica package, or using another
        representation, e.g., a binary representation), you must rename the
        root-level name of the package for your distribution. In version 1
        you could keep the name (so, version 2 is more restrictive). The
        reason of this restriction is to reduce the risk that Modelica
        packages are available that have identical names, but different
        functionality.</p>
        <li><p>
        Modelica License 1 states that &ldquo;It is not allowed to charge a
        fee for the original version or a modified version of the software,
        besides a reasonable fee for distribution and support&rdquo;.
        Version 2 has a similar intention for all Original Work under
        <u>Modelica License 2</u> (to remain free of charge and open source)
        but states this more clearly as &ldquo;No fee, neither as a
        copyright-license fee, nor as a selling fee for the copy as such may
        be charged&rdquo;. Contrary to version 1, Modelica License 2 has no
        restrictions on fees for Derivative Work that is provided under a
        different license (so, version 2 is clearer and has fewer
        restrictions).</p>
        <li><p>
        Modelica License 2 introduces several useful provisions for the
        licensee (articles 5, 6, 12), and for the licensor (articles 7, 12,
        13, 14) that have no counter part in version 1.</p>
        <li><p>
        Modelica License 2 can be applied to all type of work, including
        documents, images and data files, contrary to version 1 that was
        dedicated for software only (so, version 2 is more general).</p>
</ol>

<p><b>Can I distribute a
Modelica package (under Modelica License 2) as part of my commercial
Modelica modeling and simulation environment?</b></p>
<p>Yes,
according to Section 2c). However, you are not allowed to charge a
fee for this part of your environment. Of course, you can charge for
your part of the environment.
</p>

<p><b>Can I distribute a
Modelica package (under Modelica License 2) under a different
license?</b></p>
<p>No.
The license of an unmodified Modelica package cannot be changed
according to Sections 2c) and 2d). This means that you cannot <u>sell</u>
copies of it, any distribution has to be free of charge.</p>

<p><b>Can I distribute a
Modelica package (under Modelica License 2) under a different license
when I first encrypt the package?</b></p>
<p>No.
Merely encrypting a package does not qualify for Derivative Work and
therefore the encrypted package has to stay under Modelica License 2.</p>

<p><b>Can I distribute a
Modelica package (under Modelica License 2) under a different license
when I first add classes to the package?</b></p>
<p>No.
The package itself remains unmodified, i.e., it is Original Work, and
therefore the license for this part must remain under Modelica
License 2. The newly added classes can be, however, under a different
license.
</p>

<p><b>Can
I copy a class out of a Modelica package (under Modelica License 2)
and include it </b><u><b>unmodified</b></u><b> in a Modelica package
under a </b><u><b>commercial/proprietary license</b></u><b>?</b></p>
<p>No,
according to article 2c). However, you can include model, block,
function, package, record and connector classes in your Modelica
package under <u>Modelica License 2</u>. This means that your
Modelica package could be under a commercial/proprietary license, but
one or more classes of it are under Modelica License 2.<br>Note, a
&ldquo;type&rdquo; class (e.g., type Angle = Real(unit=&rdquo;rad&rdquo;))
can be copied and included unmodified under a commercial/proprietary
license (for details, see the next question).</p>

<p><b>Can
I copy a type class or </b><u><b>part</b></u><b> of a model, block,
function, record, connector class, out of a Modelica package (under
Modelica License 2) and include it modified or unmodified in a
Modelica package under a </b><u><b>commercial/proprietary</b></u><b>
license</b></p>
<p>Yes,
according to article 2d), since this will in the end usually qualify
as Derivative Work. The reasoning is the following: A type class or
part of another class (e.g., an equation, a declaration, part of a
class description) cannot be utilized &ldquo;by its own&rdquo;. In
order to make this &ldquo;usable&rdquo;, you have to add additional
code in order that the class can be utilized. This is therefore
usually Derivative Work and Derivative Work can be provided under a
different license. Note, this only holds, if the additional code
introduced is sufficient to qualify for Derivative Work. Merely, just
copying a class and changing, say, one character in the documentation
of this class would be no Derivative Work and therefore the copied
code would have to stay under Modelica License 2.</p>

<p><b>Can
I copy a class out of a Modelica package (under Modelica License 2)
and include it in </b><u><b>modified </b></u><b>form in a
</b><u><b>commercial/proprietary</b></u><b> Modelica package?</b></p>
<p>Yes.
If the modification can be seen as a &ldquo;Derivative Work&rdquo;,
you can place it under your commercial/proprietary license. If the
modification does not qualify as &ldquo;Derivative Work&rdquo; (e.g.,
bug fixes, vendor specific annotations), it must remain under
Modelica License 2. This means that your Modelica package could be
under a commercial/proprietary license, but one or more parts of it
are under Modelica License 2.</p>

<p><b>Can I distribute a
&ldquo;save total model&rdquo; under my commercial/proprietary
license, even if classes under Modelica License 2 are included?</b></p>
<p>Your
classes of the &ldquo;save total model&rdquo; can be distributed
under your commercial/proprietary license, but the classes under
Modelica License 2 must remain under Modelica License 2. This means
you can distribute a &ldquo;save total model&rdquo;, but some parts
might be under Modelica License 2.</p>

<p><b>Can I distribute a
Modelica package (under Modelica License 2) in encrypted form?</b></p>
<p>Yes.
Note, if the encryption does not allow &ldquo;copying&rdquo; of
classes (in to unencrypted Modelica source code), you have to send
the Modelica source code of this package to your customer, if he/she
wishes it, according to article&nbsp;6.</p>

<p><b>Can I distribute an
executable under my commercial/proprietary license, if the model from
which the executable is generated uses models from a Modelica package
under Modelica License 2?</b></p>
<p>Yes,
according to article 2d), since this is seen as Derivative Work. The
reasoning is the following: An executable allows the simulation of a
concrete model, whereas models from a Modelica package (without
pre-processing, translation, tool run-time library) are not able to
be simulated without tool support. By the processing of the tool and
by its run-time libraries, significant new functionality is added (a
model can be simulated whereas previously it could not be simulated)
and functionality available in the package is removed (e.g., to build
up a new model by dragging components of the package is no longer
possible with the executable).</p>

<p><b>Is my modification to
a Modelica package (under Modelica License 2) a Derivative Work?</b></p>
<p>It
is not possible to give a general answer to it. To be regarded as &quot;an
original work of authorship&quot;, a derivative work must be
different enough from the original or must contain a substantial
amount of new material. Making minor changes or additions of little
substance to a preexisting work will not qualify the work as a new
version for such purposes.
</p>

<h6>Using or Distributing a Modelica <u>Document</u> under the Modelica License 2</h6>

<p>This
section is devoted especially for the following applications:</p>
<ol type=\"a\">
        <li><p>
        A Modelica tool extracts information out of a Modelica package and
        presents the result in form of a &ldquo;manual&rdquo; for this
        package in, e.g., html, doc, or pdf format.</p>
        <li><p>
        The Modelica language specification is a document defining the
        Modelica language. It will be licensed under Modelica License 2.</p>
        <li><p>
        Someone writes a book about the Modelica language and/or Modelica
        packages and uses information which is available in the Modelica
        language specification and/or the corresponding Modelica package.</p>
</ol>

<p><b>Can I sell a manual
that was basically derived by extracting information automatically
from a Modelica package under Modelica License 2 (e.g., a &ldquo;reference
guide&rdquo; of the Modelica Standard Library):</b></p>
<p>Yes.
Extracting information from a Modelica package, and providing it in a
human readable, suitable format, like html, doc or pdf format, where
the content is significantly modified (e.g. tables with interface
information are constructed from the declarations of the public
variables) qualifies as Derivative Work and there are no restrictions
to charge a fee for Derivative Work under alternative 2d).</p>

<p><b>Can
I copy a text passage out of a Modelica document (under Modelica
License 2) and use it </b><u><b>unmodified</b></u><b> in my document
(e.g. the Modelica syntax description in the Modelica Specification)?</b></p>
<p>Yes.
In case you distribute your document, the copied parts are still
under Modelica License 2 and you are not allowed to charge a license
fee for this part. You can, of course, charge a fee for the rest of
your document.</p>

<p><b>Can
I copy a text passage out of a Modelica document (under Modelica
License 2) and use it in </b><u><b>modified</b></u><b> form in my
document?</b></p>
<p>Yes,
the creation of Derivative Works is allowed. In case the content is
significantly modified this qualifies as Derivative Work and there
are no restrictions to charge a fee for Derivative Work under
alternative 2d).</p>

<p><b>Can I sell a printed
version of a Modelica document (under Modelica License 2), e.g., the
Modelica Language Specification?</b></p>
<p>No,
if you are not the copyright-holder, since article 2c) does not allow
a selling fee for a (in this case physical) copy. However, mere
printing and shipping costs may be recovered.</p>
</body>
</html>"));
end ModelicaLicense2;

  class Contact "Contact"
    extends Modelica.Icons.Contact;
    annotation (Documentation(info="<html>
<dl>
<dt><b>Main Authors:</b></dt>
<dd>Bernhard Thiele<br>
    <a href=\"https://github.com/bernhard-thiele\">at Github</a><br></dd>
<dd>Tobias Bellmann<br>
    German Aerospace Center (DLR)<br>
    Robotics and Mechatronics Center<br>
    Institute of System Dynamics and Control<br>
    Postfach 1116<br>
    D-82230 Wessling<br>
    Germany<br>
    email: <a href=\"mailto:Tobias.Bellmann@dlr.de\">Tobias.Bellmann@dlr.de</a><br></dd>
</dl>
<p>
The authors are open to include contributions.
</p>
<p> Please note that You can use the <b>issue tracker</b> provided by GitHub to report bugs or other issues (<a href=\"https://github.com/modelica/Modelica_DeviceDrivers/issues\">https://github.com/modelica/Modelica_DeviceDrivers/issues</a>)</p>

<p>
The following people have directly contributed to the implementation
of the library:
</p>

<table border=1 cellspacing=0 cellpadding=2>
<tr><td valign=\"top\"><b>Dominik Sommer</b> </td>
   <td valign=\"top\"> Institute of System Dynamics and Control<br>
     DLR, German Aerospace Center, <br>
     Oberpfaffenhofen, Germany</td>
   <td valign=\"top\"> Blocks.Communication.SerialPortReceive<br>
                    Blocks.Communication.SerialPortSend<br>
                    Communication.SerialPort<br>
                    Communication.SerialPort_</td>
</tr>
<tr><td valign=\"top\"><b><a href=\"https://github.com/tbeu/\">tbeu</a></b> </td>
   <td valign=\"top\"></td>
   <td valign=\"top\"> Many fixes and good proposals, especially regarding the SimulationX support.</td>
</tr>

</table>
</html>"));
  end Contact;

  annotation (__Dymola_DocumentationClass=true, Documentation(info="<html>
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
<li><a href=\"modelica://Modelica_DeviceDrivers.UsersGuide.ModelicaLicense2\">Modelica License 2</a>
    is the legal license text under which this library is submitted.</li>
<li><a href=\"modelica://Modelica_DeviceDrivers.UsersGuide.Contact\">Contact</a>
    provides information about the authors of the library as well as
    acknowledgments.</li>
</ol>


</html>"));
end UsersGuide;
