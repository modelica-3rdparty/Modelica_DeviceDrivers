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
    parameter Modelica.SIunits.Period sampleTime=0.01 "Sample time for input update";
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
end Communication;
