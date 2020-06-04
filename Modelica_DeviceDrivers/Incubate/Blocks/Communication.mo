within Modelica_DeviceDrivers.Incubate.Blocks;
package Communication
   extends Modelica.Icons.Package;
  model UDPBlockingReceive
    "A block for receiving UDP packets which blocks if no new data is available"
    extends Modelica_DeviceDrivers.Utilities.Icons.BaseIcon;
    extends Modelica_DeviceDrivers.Utilities.Icons.UDPconnection;
    extends Modelica.Icons.UnderConstruction;
    import Modelica_DeviceDrivers.Packaging.SerialPackager;
    import Modelica_DeviceDrivers.Packaging.alignAtByteBoundary;
    import Modelica_DeviceDrivers.Communication.UDPSocket;
    parameter Modelica.Units.SI.Period sampleTime=0.01
      "Sample time for input update";
    parameter Boolean autoBufferSize = true
      "true, buffer size is deduced automatically, otherwise set it manually"
      annotation(Dialog(group="Incoming data"), choices(checkBox=true));
    parameter Integer userBufferSize=16*1024
      "Buffer size of message data in bytes (if not deduced automatically)" annotation(Dialog(enable=not autoBufferSize, group="Incoming data"));
    parameter Integer port_recv=10001
      "Listening port number of the server. Must be unique on the system"
      annotation (Dialog(group="Incoming data"));
    parameter Boolean blockDuringFirstSample = false
      "If true, block on datagram receive during first sampling of block equations, otherwise skip blocking for first sampling";

    Modelica_DeviceDrivers.Blocks.Interfaces.PackageOut pkgOut(pkg = SerialPackager(bufferSize))
                                       annotation (Placement(transformation(
          extent={{-20,-20},{20,20}},
          rotation=90,
          origin={108,0})));

  protected
    Integer bufferSize;
    UDPSocket socket = UDPSocket(port_recv, bufferSize);
    Boolean newData;
    Boolean firstSample(start=true, fixed=true);

  algorithm
    newData := false;

    if firstSample and not blockDuringFirstSample then
      // If this is (before) first sampling of equations, don't block until new data is available
      // (unless parameter blockDuringFirstSample == true)
    else
       while not newData loop
         // loop and block until new data was received
         newData := Modelica_DeviceDrivers.Communication.UDPSocket_.getReceivedBytes(socket) > 0;
       end while;
    end if;

  equation
    when initial() then
      bufferSize = if autoBufferSize then alignAtByteBoundary(pkgOut.autoPkgBitSize) else userBufferSize;
    end when;

    pkgOut.trigger = sample(0, sampleTime);

    when pkgOut.trigger then
      pkgOut.dummy = Modelica_DeviceDrivers.Blocks.Communication.Internal.DummyFunctions.readUDP(
        socket,
        pkgOut.pkg,
        time);
    end when;
    firstSample = false; // after the first sampling of this when statement set firstSample to false

    annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,
              -100},{100,100}}), graphics={Text(extent={{-150,136},{150,96}},
              textString="%name")}), Documentation(info="<html>
<p>Supports receiving of User Datagram Protocol (UDP) datagrams.</p>
</html>"));
  end UDPBlockingReceive;

  block TextFileSource
    "A block which creates a stream of SerialPackager packages from a text file."
    extends Modelica_DeviceDrivers.Utilities.Icons.BaseIcon;
    extends
      Modelica_DeviceDrivers.Blocks.Communication.Internal.PartialSampleTrigger;
    import Modelica_DeviceDrivers.Packaging.SerialPackager;
    import Modelica_DeviceDrivers.Packaging.alignAtByteBoundary;
    import Modelica.Utilities.Streams;

    parameter Boolean autoBufferSize = true
      "true, buffer size is deduced automatically, otherwise set it manually"
      annotation(Dialog(group="Incoming data"), choices(checkBox=true));
    parameter Integer userBufferSize=16*1024
      "Buffer size of message data in bytes (if not deduced automatically)" annotation(Dialog(enable=not autoBufferSize, group="Incoming data"));

    parameter Boolean showReceivedBytesPort = false "=true, if number of received bytes port is visible" annotation(Dialog(tab="Advanced"),Evaluate=true, HideResult=true, choices(checkBox=true));
    Modelica_DeviceDrivers.Blocks.Interfaces.PackageOut pkgOut(pkg = SerialPackager(if autoBufferSize then bufferSize else userBufferSize), dummy(start=0, fixed=true))
      annotation (Placement(transformation(
          extent={{-20,-20},{20,20}},
          rotation=90,
          origin={108,0})));
    Modelica.Blocks.Interfaces.IntegerOutput nReceivedBytes(start=0,fixed=true) "Number of received bytes (including string termination character)"
      annotation (Placement(visible=showReceivedBytesPort, transformation(extent={{100,70},
              {120,90}})));

    parameter String fileName = "noFile"
      "File in which data is present"
        annotation (Dialog(
          loadSelector(filter="Text files (*.txt);;Any files (*.*)",
            caption="Open text file")));
    output Boolean endOfFile(start=false,fixed=true);
  protected
    Integer bufferSize;
    Real dummy1(start=0,fixed=true),dummy2(start=0,fixed=true);

    String line;
    Integer iline(start=0,fixed=true);
  equation
    when initial() then
      bufferSize = if autoBufferSize then alignAtByteBoundary(pkgOut.autoPkgBitSize)
         else userBufferSize;
    end when;
    pkgOut.trigger = actTrigger "using inherited trigger";
    when pkgOut.trigger then
      iline = pre(iline) + 1;
      (line, endOfFile) = Streams.readLine(fileName, iline);

      nReceivedBytes = if endOfFile then 0 else Modelica.Utilities.Strings.length(line) + 1;
      assert(nReceivedBytes <= bufferSize, "AddString: Length of string (+ string termination character) exceeds reserved bufferSize");
      // Streams.print(fileName+":"+String(iline)+" size: "+ String(nReceivedBytes));
      dummy1 =
        Modelica_DeviceDrivers.Blocks.Packaging.SerialPackager.Internal.DummyFunctions.clear(
         pkgOut.pkg, time);
      dummy2 =
        Modelica_DeviceDrivers.Blocks.Packaging.SerialPackager.Internal.DummyFunctions.addString(
        pkgOut.pkg,
        line,
        bufferSize,
        dummy1);
      pkgOut.dummy =
        Modelica_DeviceDrivers.Blocks.Packaging.SerialPackager.Internal.DummyFunctions.resetPointer(
         pkgOut.pkg, dummy2);
    end when;

    when terminal() then
      Streams.close(fileName);
    end when;

    annotation (defaultComponentName="fileSource",
            preferredView="info",
            Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,
              -100},{100,100}}), graphics={Text(extent={{-150,136},{150,96}},
              textString="%name"), Bitmap(extent={{-100,-100},{100,100}},
              fileName="modelica://Modelica_DeviceDrivers/Resources/Images/Icons/GS-text.png")}),
                                     Documentation(info="<html>
<p>A block which creates a stream of SerialPackager packages from reading a text file. It reads one line per activation and writes that line into the SerialPackager package. After end of file is reached an empty string is written to the package.</p>
</html>"));
  end TextFileSource;

  block TextFileSink
    "A block for printing to the terminal or to a text file interpreting the package content as string."
     extends Modelica_DeviceDrivers.Utilities.Icons.BaseIcon;
     extends
      Modelica_DeviceDrivers.Blocks.Communication.Internal.PartialSampleTrigger;
    import Modelica_DeviceDrivers.Packaging.SerialPackager;
    import Modelica.Utilities.Streams;

    parameter Boolean printToTerminal = true
      "true, print to terminal, otherwise print to file below."
      annotation(choices(checkBox=true));

    parameter String fileName = "filesink.txt"
      "File to which data shall be written"
        annotation (Dialog(
          enable=not printToTerminal,
          saveSelector(filter="Text files (*.txt);;Any files (*.*)",
            caption="Save text file")));

    parameter Boolean autoBufferSize = true
      "true, buffer size is deduced automatically, otherwise set it manually."
      annotation(Dialog(group="Outgoing data"), choices(checkBox=true));
    parameter Integer userBufferSize=16*1024
      "Buffer size of message data in bytes (if not deduced automatically)." annotation(Dialog(enable=not autoBufferSize, group="Outgoing data"));
    Modelica_DeviceDrivers.Blocks.Interfaces.PackageIn pkgIn annotation (Placement(transformation(
          extent={{-20,-20},{20,20}},
          rotation=270,
          origin={-108,0})));
  protected
    Integer bufferSize;
    Real dummy1(start=0, fixed=true);
    Real dummy2(start=0, fixed=true);
    String data;
  equation
    when initial() then
      pkgIn.userPkgBitSize = if autoBufferSize then -1 else userBufferSize*8;
      pkgIn.autoPkgBitSize = 0;
      bufferSize = if autoBufferSize then
        Modelica_DeviceDrivers.Packaging.SerialPackager_.getBufferSize(pkgIn.pkg)
          else userBufferSize;
      if not printToTerminal then
        Modelica.Utilities.Files.removeFile(fileName);
      end if;
    end when;
    pkgIn.backwardTrigger = actTrigger "using inherited trigger";
    when pkgIn.trigger then
      dummy1 =
        Modelica_DeviceDrivers.Blocks.Packaging.SerialPackager.Internal.DummyFunctions.resetPointer(
         pkgIn.pkg, pkgIn.dummy);
      (data,dummy2) =
        Modelica_DeviceDrivers.Blocks.Packaging.SerialPackager.Internal.DummyFunctions.getString(
        pkgIn.pkg,
        bufferSize,
        dummy1);
        if printToTerminal then
         Streams.print(data);
        else
          Streams.print(data, fileName);
        end if;
    end when;

    when terminal() then
      if not printToTerminal then
        Streams.close(fileName);
      end if;
    end when;

    annotation (preferredView="info",
            Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,
              -100},{100,100}}), graphics={Text(extent={{-150,136},{150,96}},
              textString="%name"), Bitmap(extent={{-100,-100},{100,100}},
              fileName="modelica://Modelica_DeviceDrivers/Resources/Images/Icons/GS-text.png")}),
                                     Documentation(info="<html>
<p>A block for printing to the terminal or to a text file interpreting the package content as string.</p>
</html>"));
  end TextFileSink;
end Communication;
