within Modelica_DeviceDrivers.ClockedBlocks;
package Communication
  extends Modelica.Icons.Package;
  model SharedMemoryRead "A block for reading data from a shared memory buffer"
    extends Modelica_DeviceDrivers.Utilities.Icons.BaseIcon;
    extends Modelica_DeviceDrivers.Utilities.Icons.SharedMemoryIcon;
    extends
      Modelica_DeviceDrivers.Utilities.Icons.PartialClockedDeviceDriverIcon;
    import Modelica_DeviceDrivers.Packaging.SerialPackager;
    import Modelica_DeviceDrivers.Packaging.alignAtByteBoundary;
    import Modelica_DeviceDrivers.Communication.SharedMemory;
    import Modelica_DeviceDrivers.Communication.SharedMemory_;

    parameter Boolean autoBufferSize = false
      "true, buffer size is deduced automatically, otherwise set it manually"
      annotation(Dialog(group="Shared memory partition"), choices(checkBox=true));
    parameter Integer userBufferSize=16*1024
      "Buffer size of shared memory partition in bytes (if not deduced automatically)"
      annotation(Dialog(enable=not autoBufferSize, group="Shared memory partition"));
    parameter String memoryID="sharedMemory" "ID of the shared memory buffer" annotation(Dialog(group="Shared memory partition"));
    parameter Boolean cleanup = true "true, unlink shared memory at process termination, otherwise no unlink ⇒ 'memoryID' can still be opened (Linux specific, otherwise no effect)"
      annotation(Dialog(group="Shared memory partition"), choices(checkBox=true));

    Interfaces.PackageOut pkgOut annotation (Placement(
          transformation(
          extent={{-20,-20},{20,20}},
          rotation=90,
          origin={108,0})));

  protected
    Integer bufferSize;
    SharedMemory sm;
    Boolean initialized(start=false);
    Real dummy(start=0);
    Real Ts = interval();
  equation

    if not previous(initialized) then
      bufferSize = if autoBufferSize then alignAtByteBoundary(pkgOut.autoPkgBitSize)
         else userBufferSize;
      pkgOut.pkg = SerialPackager(bufferSize);
      sm = SharedMemory(memoryID,bufferSize);
      initialized = true;
    else
      pkgOut.pkg = previous(pkgOut.pkg);
      bufferSize = previous(bufferSize);
      sm = previous(sm);
      initialized = previous(initialized);
    end if;

    dummy = previous(dummy) + Ts;
    pkgOut.dummy = Modelica_DeviceDrivers.ClockedBlocks.Communication.Internal.DummyFunctions.readSharedMemory(
      sm,
      pkgOut.pkg,
      dummy);
      annotation (preferredView="info",
                Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,
              -100},{100,100}}), graphics={Text(extent={{-150,136},{150,96}},
              textString="%name")}), Documentation(info="<html>
<p>Supports reading from a named shared memory partition. The name of the shared memory partition is
provided by the parameter <b>memoryID</b>. If the shared memory partition does not yet exist during initialization, it is created.</p>
</html>"));
  end SharedMemoryRead;

  model SharedMemoryWrite
    "A block for writing data into a shared memory buffer"
    import Modelica_DeviceDrivers;
    extends Modelica_DeviceDrivers.Utilities.Icons.BaseIcon;
    extends Modelica_DeviceDrivers.Utilities.Icons.SharedMemoryIcon;
    extends
      Modelica_DeviceDrivers.Utilities.Icons.PartialClockedDeviceDriverIcon;
    import Modelica_DeviceDrivers.Packaging.SerialPackager;
    import Modelica_DeviceDrivers.Communication.SharedMemory;

    parameter Boolean autoBufferSize = false
      "true, buffer size is deduced automatically, otherwise set it manually"
      annotation(Dialog(group="Shared memory partition"), choices(checkBox=true));
    parameter Integer userBufferSize=16*1024
      "Buffer size of shared memory partition in bytes (if not deduced automatically)"
      annotation(Dialog(enable=not autoBufferSize, group="Shared memory partition"));
    parameter String memoryID="sharedMemory" "ID of the shared memory buffer" annotation(Dialog(group="Shared memory partition"));
    parameter Boolean cleanup = true "true, unlink shared memory at process termination, otherwise no unlink ⇒ 'memoryID' can still be opened (Linux specific, otherwise no effect)"
      annotation(Dialog(group="Shared memory partition"), choices(checkBox=true));

    Interfaces.PackageIn pkgIn annotation (Placement(
          transformation(
          extent={{-20,-20},{20,20}},
          rotation=270,
          origin={-108,0})));
  protected
    SharedMemory sm; // = SharedMemory(memoryID, userBufferSize);
    Integer bufferSize;
    Boolean initialized(start=false);
    Real dummy;
  algorithm
    /* FIXME: This stuff needs to be in algorithm section since otherwise there is an algebraic loop if used
     with the packger. Why? */
    if not initialized then
      sm := SharedMemory(memoryID, bufferSize);
      initialized :=true;
    else
      sm := previous(sm);
      initialized :=previous(initialized);
    end if;
  equation
    pkgIn.userPkgBitSize = if autoBufferSize then -1 else userBufferSize*8;
    pkgIn.autoPkgBitSize = 0;
    bufferSize = if autoBufferSize then Modelica_DeviceDrivers.Packaging.SerialPackager_.getBufferSize(pkgIn.pkg) else userBufferSize;
    dummy = Modelica_DeviceDrivers.ClockedBlocks.Communication.Internal.DummyFunctions.writeSharedMemory(
      sm,
      pkgIn.pkg,
      bufferSize,
      pkgIn.dummy);

    annotation (preferredView="info",
            Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,
              -100},{100,100}}), graphics={Text(extent={{-150,136},{150,96}},
              textString="%name")}), Documentation(info="<html>
<p>Supports writing to a named shared memory partition. The name of the shared memory partition is
provided by the parameter <b>memoryID</b>. If the shared memory partition does not yet exist during initialization, it is created.</p>
</html>"));
  end SharedMemoryWrite;

  model UDPReceive "a block for receiving UDP datagrams"
    extends Modelica_DeviceDrivers.Utilities.Icons.BaseIcon;
    extends Modelica_DeviceDrivers.Utilities.Icons.UDPconnection;
    extends
      Modelica_DeviceDrivers.Utilities.Icons.PartialClockedDeviceDriverIcon;
    import Modelica_DeviceDrivers.Packaging.SerialPackager;
    import Modelica_DeviceDrivers.Packaging.alignAtByteBoundary;
    import Modelica_DeviceDrivers.Communication.UDPSocket;

    parameter Boolean autoBufferSize = true
      "true, buffer size is deduced automatically, otherwise set it manually"
      annotation(Dialog(group="Incoming data"), choices(checkBox=true));
    parameter Integer userBufferSize=16*1024
      "Buffer size of message data in bytes (if not deduced automatically)" annotation(Dialog(enable=not autoBufferSize, group="Incoming data"));
    parameter Integer port_recv=10001
      "Listening port number of the server. Must be unique on the system"
      annotation (Dialog(group="Incoming data"));
    parameter Boolean showReceivedBytesPort = false "=true, if number of received bytes port is visible" annotation(Dialog(tab="Advanced"),Evaluate=true, HideResult=true, choices(checkBox=true));
    parameter Boolean useRecvThread = true "true, dedicated receiving thread writes datagrams into shared buffer (latest available datagram is used by simulation thread). Otherwise, simulation progress is blocked until a new incoming datagram is available"  annotation(Dialog(group="Incoming data"), choices(checkBox=true));
    parameter Boolean skipFirstTick = false "true, skip call to readUDP(...) at first clock tick, e.g., to avoid infinite blocking if 'useRecvThread=false' and the 'UDPSend' block is within the same model" annotation(Dialog(group="Incoming data"), choices(checkBox=true));

    Interfaces.PackageOut pkgOut  annotation (Placement(
          transformation(
          extent={{-20,-20},{20,20}},
          rotation=90,
          origin={108,0})));
     Modelica.Blocks.Interfaces.IntegerOutput nRecvBytes
       "Number of received bytes" annotation (Placement(visible=
             showReceivedBytesPort, transformation(extent={{100,70},{120,90}})));
     output Integer nRecvbufOverwrites "Accumulated number of times new data was received without having been read out (retrieved) by Modelica";
  protected
    Integer bufferSize;
    UDPSocket socket;
    Boolean initialized(start=false);
    Real dummy(start=0);
    Real Ts = interval();
  equation

    if not previous(initialized) then
      bufferSize = if autoBufferSize then alignAtByteBoundary(pkgOut.autoPkgBitSize)
         else userBufferSize;
      pkgOut.pkg = SerialPackager(bufferSize);
  //    Modelica.Utilities.Streams.print("Open Socket "+String(port_recv)+" with bufferSize "+String(bufferSize));
      socket = UDPSocket(port_recv, bufferSize, useRecvThread);
      initialized = true;
    else
      pkgOut.pkg = previous(pkgOut.pkg);
      bufferSize = previous(bufferSize);
      socket = previous(socket);
      initialized = previous(initialized);
    end if;

    dummy = previous(dummy) + Ts;

    // if skipFirstTick=true skip readUDP(...) at first clock tick
      (pkgOut.dummy,nRecvBytes,nRecvbufOverwrites) = Modelica_DeviceDrivers.ClockedBlocks.Communication.Internal.DummyFunctions.readUDP_Conditional(
        socket,
        pkgOut.pkg,
        not skipFirstTick or previous(initialized),
        dummy);


    annotation (preferredView="info",
            Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,
              -100},{100,100}}), graphics={Text(extent={{-150,136},{150,96}},
              textString="%name")}), Documentation(info="<html>
<p>Supports receiving of User Datagram Protocol (UDP) datagrams.</p>
</html>"));
  end UDPReceive;

  model UDPSend "A block for sending UDP datagrams"
    import Modelica_DeviceDrivers;
    extends Modelica_DeviceDrivers.Utilities.Icons.BaseIcon;
    extends Modelica_DeviceDrivers.Utilities.Icons.UDPconnection;
    extends
      Modelica_DeviceDrivers.Utilities.Icons.PartialClockedDeviceDriverIcon;
    import Modelica_DeviceDrivers.Packaging.SerialPackager;
    import Modelica_DeviceDrivers.Communication.UDPSocket;

    parameter Boolean autoBufferSize = true
      "true, buffer size is deduced automatically, otherwise set it manually."
      annotation(Dialog(group="Outgoing data"), choices(checkBox=true));
    parameter Integer userBufferSize=16*1024
      "Buffer size of message data in bytes (if not deduced automatically)." annotation(Dialog(enable=not autoBufferSize, group="Outgoing data"));
    parameter String IPAddress="127.0.0.1" "IP address of remote UDP server"
      annotation (Dialog(group="Outgoing data"));
    parameter Integer port_send=10002 "Target port of the receiving UDP server"
      annotation (Dialog(group="Outgoing data"));

    Interfaces.PackageIn pkgIn annotation (Placement(
          transformation(
          extent={{-20,-20},{20,20}},
          rotation=270,
          origin={-108,0})));

  protected
    UDPSocket socket = UDPSocket(0);
    Integer bufferSize;
    Real dummy;
  equation

      pkgIn.userPkgBitSize = if autoBufferSize then -1 else userBufferSize*8;
      pkgIn.autoPkgBitSize = 0;
      bufferSize = if autoBufferSize then Modelica_DeviceDrivers.Packaging.SerialPackager_.getBufferSize(pkgIn.pkg) else userBufferSize;

  //    socket = previous(socket);

    dummy = Modelica_DeviceDrivers.ClockedBlocks.Communication.Internal.DummyFunctions.sendToUDP(
      socket,
      IPAddress,
      port_send,
      pkgIn.pkg,
      bufferSize,
      pkgIn.dummy);

    annotation (preferredView="info",
            Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,
              -100},{100,100}}), graphics={Text(extent={{-150,136},{150,96}},
              textString="%name")}), Documentation(info="<html>
<p>Supports sending of User Datagram Protocol (UDP) datagrams.</p>
</html>"));
  end UDPSend;

  package Internal
    extends Modelica.Icons.InternalPackage;
    package DummyFunctions
      extends Modelica.Icons.InternalPackage;
      function readSharedMemory
        input Modelica_DeviceDrivers.Communication.SharedMemory sm;
        input Modelica_DeviceDrivers.Packaging.SerialPackager pkg;
        input Real dummy;
        output Real dummy2;
      algorithm
        Modelica_DeviceDrivers.Communication.SharedMemory_.read(sm, pkg);
        dummy2 := dummy;
      end readSharedMemory;

      function writeSharedMemory
        input Modelica_DeviceDrivers.Communication.SharedMemory sm;
        input Modelica_DeviceDrivers.Packaging.SerialPackager pkg;
        input Integer len;
        input Real dummy;
        output Real dummy2;
      algorithm
        Modelica_DeviceDrivers.Communication.SharedMemory_.write(sm, pkg, len);
        dummy2 := dummy;
      end writeSharedMemory;

      function readUDP_Conditional
        input Modelica_DeviceDrivers.Communication.UDPSocket socket;
        input Modelica_DeviceDrivers.Packaging.SerialPackager pkg;
        input Boolean read_condition "true, call 'read' function, otherwise skip it and return 'nRecvBytes=0' and 'nRecvbufOverwrites=0'";
        input Real dummy;
        output Real dummy2;
        output Integer nRecvBytes;
        output Integer nRecvbufOverwrites;
      algorithm
        if read_condition then
          (nRecvBytes, nRecvbufOverwrites) :=
            Modelica_DeviceDrivers.Communication.UDPSocket_.read(socket, pkg);
        else
          nRecvBytes := 0;
          nRecvbufOverwrites := 0;
        end if;

        dummy2 := dummy;
      end readUDP_Conditional;

      function sendToUDP
        input Modelica_DeviceDrivers.Communication.UDPSocket socket;
        input String ipAddress "IP address where data has to be sent";
        input Integer port "Port number where data has to be sent";
        input Modelica_DeviceDrivers.Packaging.SerialPackager pkg;
        input Integer dataSize "Size of data";
        input Real dummy;
        output Real dummy2;
      algorithm
        Modelica_DeviceDrivers.Communication.UDPSocket_.sendTo(socket, ipAddress, port, pkg, dataSize);
        dummy2 := dummy;
      end sendToUDP;

    end DummyFunctions;

  end Internal;
end Communication;
