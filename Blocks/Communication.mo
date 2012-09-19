within Modelica_DeviceDrivers.Blocks;
package Communication
    extends Modelica.Icons.Package;
  model SharedMemoryRead
    "A block for reading data out of shared memory buffers"
    extends Modelica_DeviceDrivers.Utilities.Icons.BaseIcon;
    extends Modelica_DeviceDrivers.Utilities.Icons.SharedMemoryIcon;
    import Modelica_DeviceDrivers.Packaging.SerialPackager;
    import Modelica_DeviceDrivers.Packaging.alignAtByteBoundery;
    import Modelica_DeviceDrivers.Communication.SharedMemory;
    parameter Real sampleTime=0.01 "Sample time for input update";
    parameter Boolean autoBufferSize = false
      "true, buffer size is deduced automatically, otherwise set it manually"
      annotation(Dialog(group="Shared memory partition"), choices(__Dymola_checkBox=true));
    parameter Integer userBufferSize=16*1024
      "Buffer size of shared memory partition in bytes (if not deduced automatically)"
                                                                                       annotation(Dialog(enable=not autoBufferSize, group="Shared memory partition"));
    parameter String memoryID="sharedMemory" "ID of the shared memory buffer" annotation(Dialog(group="Shared memory partition"));
    Modelica_DeviceDrivers.Blocks.Interfaces.PackageOut pkgOut
                                                           annotation (Placement(
          transformation(
          extent={{-20,-20},{20,20}},
          rotation=90,
          origin={108,0})));
  protected
    SharedMemory sm;
    Integer bufferSize;
  equation
    when (initial()) then
      bufferSize = if autoBufferSize then alignAtByteBoundery(pkgOut.autoPkgBitSize)
        else userBufferSize;
      pkgOut.pkg = SerialPackager( bufferSize);
      sm = SharedMemory(memoryID,bufferSize);
    end when;
    pkgOut.trigger = sample(0,sampleTime);
    when pkgOut.trigger then
      pkgOut.dummy = Modelica_DeviceDrivers.Blocks.Packaging.SerialPackager.Internal.DummyFunctions.setPackage(
        pkgOut.pkg,
        Modelica_DeviceDrivers.Communication.SharedMemory.read(sm),
        bufferSize,
        time);
    end when;
      annotation (preferedView="info",
            Dialog(group="Incoming data"),
                Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,
              -100},{100,100}}), graphics={Text(extent={{-150,136},{150,96}},
              textString="%name")}), Diagram(coordinateSystem(preserveAspectRatio=true,
                   extent={{-100,-100},{100,100}}), graphics),
      Documentation(info="<html>
<p>Supports reading from a named shared memory partition. The name of the shared memory partition is 
provided by the parameter <b>memoryID</b>. If the shared memory partition does not yet exist during initialization, it is created.</p>
</html>"));
  end SharedMemoryRead;

  model SharedMemoryWrite "A block for writing data in a shared memory"
    extends Modelica_DeviceDrivers.Utilities.Icons.BaseIcon;
    extends Modelica_DeviceDrivers.Utilities.Icons.SharedMemoryIcon;
    import Modelica_DeviceDrivers.Packaging.SerialPackager;
    import Modelica_DeviceDrivers.Communication.SharedMemory;
    parameter Real sampleTime=0.01 "Sample time for update";
    parameter Boolean autoBufferSize = false
      "true, buffer size is deduced automatically, otherwise set it manually"
      annotation(Dialog(group="Shared memory partition"), choices(__Dymola_checkBox=true));
    parameter Integer userBufferSize=16*1024
      "Buffer size of shared memory partition in bytes (if not deduced automatically)"
                                                                                       annotation(Dialog(enable=not autoBufferSize, group="Shared memory partition"));
    parameter String memoryID="sharedMemory" "ID of the shared memory buffer" annotation(Dialog(group="Shared memory partition"));
    Interfaces.PackageIn pkgIn         annotation (Placement(
          transformation(
          extent={{-20,20},{20,-20}},
          rotation=90,
          origin={-108,0})));
  protected
    SharedMemory sm;
    Integer bufferSize;
    Real dummy;
  equation
    when (initial()) then
      pkgIn.userPkgBitSize = if autoBufferSize then -1 else userBufferSize*8;
      pkgIn.autoPkgBitSize = 0;
      bufferSize = if autoBufferSize then SerialPackager.getBufferSize(pkgIn.pkg) else userBufferSize;
      sm = SharedMemory(memoryID, bufferSize);
    end when;
    pkgIn.backwardTrigger = sample(0, sampleTime);
    when pkgIn.trigger then
      dummy =
        Modelica_DeviceDrivers.Blocks.Communication.Internal.DummyFunctions.writeSharedMemory(
        sm,
        SerialPackager.getPackage(pkgIn.pkg),
        bufferSize,
        pkgIn.dummy);
    end when;
    annotation (preferedView="info",
            Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,
              -100},{100,100}}), graphics={Text(extent={{-150,136},{150,96}},
              textString="%name")}), Diagram(coordinateSystem(preserveAspectRatio=true,
                    extent={{-100,-100},{100,100}}), graphics),
      Documentation(info="<html>
<p>Supports writing to a named shared memory partition. The name of the shared memory partition is 
provided by the parameter <b>memoryID</b>. If the shared memory partition does not yet exist during initialization, it is created.</p>
</html>"));
  end SharedMemoryWrite;

  model UDPReceive "A block for receiving UDP datagrams"
    extends Modelica_DeviceDrivers.Utilities.Icons.BaseIcon;
    extends Modelica_DeviceDrivers.Utilities.Icons.UDPconnection;
    import Modelica_DeviceDrivers.Packaging.SerialPackager;
    import Modelica_DeviceDrivers.Packaging.alignAtByteBoundery;
    import Modelica_DeviceDrivers.Communication.UDPSocket;
    parameter Real sampleTime=0.01 "Sample time for input update";
    parameter Boolean autoBufferSize = true
      "true, buffer size is deduced automatically, otherwise set it manually"
      annotation(Dialog(group="Incoming data"), choices(__Dymola_checkBox=true));
    parameter Integer userBufferSize=16*1024
      "Buffer size of message data in bytes (if not deduced automatically)" annotation(Dialog(enable=not autoBufferSize, group="Incoming data"));
    parameter Integer port_recv=10001
      "Listening port number of the server. Must be unique on the system"
      annotation (Dialog(group="Incoming data"));
    Modelica_DeviceDrivers.Blocks.Interfaces.PackageOut pkgOut
                                       annotation (Placement(transformation(
          extent={{-20,-20},{20,20}},
          rotation=90,
          origin={108,0})));

  protected
    Integer bufferSize;
    UDPSocket socket;
  equation
    when (initial()) then
      bufferSize = if autoBufferSize then alignAtByteBoundery(pkgOut.autoPkgBitSize)
        else userBufferSize;
      pkgOut.pkg = SerialPackager( bufferSize);
  //    Modelica.Utilities.Streams.print("Open Socket "+String(port_recv)+" with bufferSize "+String(bufferSize));
      socket = UDPSocket(port_recv,bufferSize);
    end when;
    pkgOut.trigger = sample(0,sampleTime);

    when pkgOut.trigger then
      pkgOut.dummy = Modelica_DeviceDrivers.Blocks.Packaging.SerialPackager.Internal.DummyFunctions.setPackage(
        pkgOut.pkg,
        Modelica_DeviceDrivers.Communication.UDPSocket.read(socket),
        bufferSize,
        time);
    end when;

    annotation (preferedView="info",
            Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,
              -100},{100,100}}), graphics={Text(extent={{-150,136},{150,96}},
              textString="%name")}), Diagram(coordinateSystem(preserveAspectRatio=true,
                   extent={{-100,-100},{100,100}}), graphics),
      Documentation(info="<html>
<p>Supports receiving of User Datagram Protocol (UDP) datagrams.</p>
</html>"));
  end UDPReceive;

  model UDPSend "A block for sending UDP datagrams"
    extends Modelica_DeviceDrivers.Utilities.Icons.BaseIcon;
    extends Modelica_DeviceDrivers.Utilities.Icons.UDPconnection;
    import Modelica_DeviceDrivers.Packaging.SerialPackager;
    import Modelica_DeviceDrivers.Communication.UDPSocket;

    parameter Real sampleTime=0.01 "Sample time for update";
    parameter Boolean autoBufferSize = true
      "true, buffer size is deduced automatically, otherwise set it manually."
      annotation(Dialog(group="Outgoing data"), choices(__Dymola_checkBox=true));
    parameter Integer userBufferSize=16*1024
      "Buffer size of message data in bytes (if not deduced automatically)." annotation(Dialog(enable=not autoBufferSize, group="Outgoing data"));
    parameter String IPAddress="127.0.0.1" "IP address of remote UDP server"
        annotation (Dialog(group="Outgoing data"));
    parameter Integer port_send=10002 "Target port of the receiving UDP server"
        annotation (Dialog(group="Outgoing data"));
    Interfaces.PackageIn pkgIn         annotation (Placement(transformation(
          extent={{-20,-20},{20,20}},
          rotation=270,
          origin={-108,0})));
  protected
    UDPSocket socket;
    Integer bufferSize;
    Real dummy;
  equation
    when (initial()) then
      pkgIn.userPkgBitSize = if autoBufferSize then -1 else userBufferSize*8;
      pkgIn.autoPkgBitSize = 0;
      bufferSize = if autoBufferSize then SerialPackager.getBufferSize(pkgIn.pkg) else userBufferSize;
      socket = UDPSocket(0);
    end when;
    pkgIn.backwardTrigger = sample(0, sampleTime);
    when pkgIn.trigger then
      dummy =
         Modelica_DeviceDrivers.Blocks.Communication.Internal.DummyFunctions.sendToUDP(
        socket,
        IPAddress,
        port_send,
        SerialPackager.getPackage(pkgIn.pkg),
        bufferSize,
        pkgIn.dummy);
    end when;
    annotation (preferedView="info",
            Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,
              -100},{100,100}}), graphics={Text(extent={{-150,136},{150,96}},
              textString="%name")}), Diagram(coordinateSystem(preserveAspectRatio=true,
                    extent={{-100,-100},{100,100}}), graphics),
      Documentation(info="<html>
<p>Supports sending of User Datagram Protocol (UDP) datagrams.</p>
</html>"));
  end UDPSend;



  package Internal
    extends Modelica_DeviceDrivers.Utilities.Icons.InternalPackage;
    package DummyFunctions
      extends Modelica_DeviceDrivers.Utilities.Icons.InternalPackage;
      function sendToUDP
        import Modelica_DeviceDrivers.Communication.UDPSocket;
        input UDPSocket socket;
        input String ipAddress "IP address where data has to be sent";
        input Integer port "Port number where data has to be sent";
        input String data "Data to be sent";
        input Integer dataSize "Size of data";
        input Real dummy;
        output Real dummy2;
      algorithm
        Modelica_DeviceDrivers.Communication.UDPSocket.sendTo(socket, ipAddress, port,data, dataSize);
        dummy2 :=dummy;
      end sendToUDP;

      function writeSharedMemory
        input Modelica_DeviceDrivers.Communication.SharedMemory sm;
        input String data;
        input Integer len;
        input Real dummy;
        output Real dummy2;
      algorithm
        Modelica_DeviceDrivers.Communication.SharedMemory.write(sm,data,len);
        dummy2 :=dummy;
      end writeSharedMemory;
    end DummyFunctions;
  end Internal;
end Communication;
