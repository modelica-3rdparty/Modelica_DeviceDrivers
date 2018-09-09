within Modelica_DeviceDrivers.Blocks;
package Communication
    extends Modelica.Icons.Package;
  block SharedMemoryRead
    "A block for reading data out of shared memory buffers"
    extends Modelica_DeviceDrivers.Utilities.Icons.BaseIcon;
    extends Modelica_DeviceDrivers.Utilities.Icons.SharedMemoryIcon;
    extends
      Modelica_DeviceDrivers.Blocks.Communication.Internal.PartialSampleTrigger;
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
    Interfaces.PackageOut pkgOut(pkg = SerialPackager(if autoBufferSize then bufferSize else userBufferSize), dummy(start=0, fixed=true))
      annotation (Placement(
          transformation(
          extent={{-20,-20},{20,20}},
          rotation=90,
          origin={108,0})));
  protected
    SharedMemory sm = SharedMemory(memoryID, bufferSize);
    Integer bufferSize;
  equation
    when initial() then
      bufferSize = if autoBufferSize then alignAtByteBoundary(pkgOut.autoPkgBitSize) else userBufferSize;
    end when;
    pkgOut.trigger = actTrigger "using inherited trigger";
    when pkgOut.trigger then
      pkgOut.dummy = Modelica_DeviceDrivers.Blocks.Communication.Internal.DummyFunctions.readSharedMemory(
        sm,
        pkgOut.pkg,
        time);
    end when;
      annotation (preferredView="info",
                Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,
              -100},{100,100}}), graphics={Text(extent={{-150,136},{150,96}},
              textString="%name")}), Documentation(info="<html>
<p>Supports reading from a named shared memory partition. The name of the shared memory partition is
provided by the parameter <b>memoryID</b>. If the shared memory partition does not yet exist during initialization, it is created.</p>
</html>"));
  end SharedMemoryRead;

  block SharedMemoryWrite "A block for writing data in a shared memory"
    import Modelica_DeviceDrivers;
    extends Modelica_DeviceDrivers.Utilities.Icons.BaseIcon;
    extends Modelica_DeviceDrivers.Utilities.Icons.SharedMemoryIcon;
    extends
      Modelica_DeviceDrivers.Blocks.Communication.Internal.PartialSampleTrigger;
    import Modelica_DeviceDrivers.Packaging.SerialPackager;
    import Modelica_DeviceDrivers.Communication.SharedMemory;
    parameter Boolean autoBufferSize = false
      "true, buffer size is deduced automatically, otherwise set it manually"
      annotation(Dialog(group="Shared memory partition"), choices(checkBox=true));
    parameter Integer userBufferSize=16*1024
      "Buffer size of shared memory partition in bytes (if not deduced automatically)"
      annotation(Dialog(enable=not autoBufferSize, group="Shared memory partition"));
    parameter String memoryID="sharedMemory" "ID of the shared memory buffer" annotation(Dialog(group="Shared memory partition"));
    Interfaces.PackageIn pkgIn annotation (Placement(
          transformation(
          extent={{-20,20},{20,-20}},
          rotation=90,
          origin={-108,0})));
  protected
    SharedMemory sm = SharedMemory(memoryID, if autoBufferSize then bufferSize else userBufferSize);
    Integer bufferSize;
    Real dummy(start=0, fixed=true);
  equation
    when initial() then
      pkgIn.userPkgBitSize = if autoBufferSize then -1 else userBufferSize*8;
      pkgIn.autoPkgBitSize = 0;
      bufferSize = if autoBufferSize then Modelica_DeviceDrivers.Packaging.SerialPackager_.getBufferSize(pkgIn.pkg) else userBufferSize;
    end when;
    pkgIn.backwardTrigger = actTrigger "using inherited trigger";
    when pkgIn.trigger then
      dummy = Modelica_DeviceDrivers.Blocks.Communication.Internal.DummyFunctions.writeSharedMemory(
        sm,
        pkgIn.pkg,
        bufferSize,
        pkgIn.dummy);
    end when;
    annotation (preferredView="info",
            Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,
              -100},{100,100}}), graphics={Text(extent={{-150,136},{150,96}},
              textString="%name")}), Documentation(info="<html>
<p>Supports writing to a named shared memory partition. The name of the shared memory partition is
provided by the parameter <b>memoryID</b>. If the shared memory partition does not yet exist during initialization, it is created.</p>
</html>"));
  end SharedMemoryWrite;

  block UDPReceive "A block for receiving UDP datagrams"
    extends Modelica_DeviceDrivers.Utilities.Icons.BaseIcon;
    extends Modelica_DeviceDrivers.Utilities.Icons.UDPconnection;
    extends
      Modelica_DeviceDrivers.Blocks.Communication.Internal.PartialSampleTrigger;
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
    Interfaces.PackageOut pkgOut(pkg = SerialPackager(if autoBufferSize then bufferSize else userBufferSize), dummy(start=0, fixed=true))
      annotation (Placement(transformation(
          extent={{-20,-20},{20,20}},
          rotation=90,
          origin={108,0})));
    Modelica.Blocks.Interfaces.IntegerOutput nRecvBytes
      "Number of received bytes" annotation (Placement(visible=
            showReceivedBytesPort, transformation(extent={{100,70},{120,90}})));
    output Integer nRecvbufOverwrites "Accumulated number of times new data was received without having been read out (retrieved) by Modelica";
  protected
    Integer bufferSize;
    UDPSocket socket = UDPSocket(port_recv, if autoBufferSize then bufferSize else userBufferSize);
  equation
    when initial() then
      bufferSize = if autoBufferSize then alignAtByteBoundary(pkgOut.autoPkgBitSize) else userBufferSize;
    end when;
    pkgOut.trigger = actTrigger "using inherited trigger";
    when pkgOut.trigger then
      (pkgOut.dummy,nRecvBytes,nRecvbufOverwrites) =
        Modelica_DeviceDrivers.Blocks.Communication.Internal.DummyFunctions.readUDP(
        socket,
        pkgOut.pkg,
        time);
    end when;

    annotation (preferredView="info",
            Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,
              -100},{100,100}}), graphics={Text(extent={{-150,136},{150,96}},
              textString="%name")}), Documentation(info="<html>
<p>Supports receiving of User Datagram Protocol (UDP) datagrams.</p>
</html>"));
  end UDPReceive;

  block UDPSend "A block for sending UDP datagrams"
    import Modelica_DeviceDrivers;
    extends Modelica_DeviceDrivers.Utilities.Icons.BaseIcon;
    extends Modelica_DeviceDrivers.Utilities.Icons.UDPconnection;
    extends
      Modelica_DeviceDrivers.Blocks.Communication.Internal.PartialSampleTrigger;
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
    Interfaces.PackageIn pkgIn annotation (Placement(transformation(
          extent={{-20,-20},{20,20}},
          rotation=270,
          origin={-108,0})));
  protected
    UDPSocket socket = UDPSocket(0, 0);
    Integer bufferSize;
    Real dummy(start=0, fixed=true);
  equation
    when initial() then
      pkgIn.userPkgBitSize = if autoBufferSize then -1 else userBufferSize*8;
      pkgIn.autoPkgBitSize = 0;
      bufferSize = if autoBufferSize then Modelica_DeviceDrivers.Packaging.SerialPackager_.getBufferSize(pkgIn.pkg) else userBufferSize;
    end when;
    pkgIn.backwardTrigger = actTrigger "using inherited trigger";
    when pkgIn.trigger then
      dummy = Modelica_DeviceDrivers.Blocks.Communication.Internal.DummyFunctions.sendToUDP(
        socket,
        IPAddress,
        port_send,
        pkgIn.pkg,
        bufferSize,
        pkgIn.dummy);
    end when;
    annotation (preferredView="info",
            Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,
              -100},{100,100}}), graphics={Text(extent={{-150,136},{150,96}},
              textString="%name")}), Documentation(info="<html>
<p>Supports sending of User Datagram Protocol (UDP) datagrams.</p>
</html>"));
  end UDPSend;

  block SerialPortReceive
    "A block for receiving serial datagrams using the serial interface"
    extends Modelica_DeviceDrivers.Utilities.Icons.SerialPortIcon;
    extends
      Modelica_DeviceDrivers.Blocks.Communication.Internal.PartialSampleTrigger;
    import Modelica_DeviceDrivers.Packaging.SerialPackager;
    import Modelica_DeviceDrivers.Packaging.alignAtByteBoundary;
    import Modelica_DeviceDrivers.Communication.SerialPort;
    import Modelica_DeviceDrivers.Utilities.Types.SerialBaudRate;
    parameter Boolean autoBufferSize = true
      "true, buffer size is deduced automatically, otherwise set it manually"
      annotation(Dialog(group="Incoming data"), choices(checkBox=true));
    parameter Integer userBufferSize=16*64
      "Buffer size of message data in bytes (if not deduced automatically)" annotation(Dialog(enable=not autoBufferSize, group="Incoming data"));
    parameter String Serial_Port="/dev/ttyPS1" "Serial port to send data"
     annotation (Dialog(group="Incoming data"));
    parameter SerialBaudRate baud= SerialBaudRate.B9600 "Serial port baud rate"
    annotation (Dialog(group="Incoming data"));
    parameter Integer parity = 0
      "set parity (0 - no parity, 1 - even, 2 - odd)"
      annotation (Dialog(group="Outgoing data"));
    Interfaces.PackageOut pkgOut(pkg = SerialPackager(if autoBufferSize then bufferSize else userBufferSize), dummy(start=0, fixed=true))
      annotation (Placement(transformation(
          extent={{-20,-20},{20,20}},
          rotation=90,
          origin={108,0})));

  protected
    Integer bufferSize;
    SerialPort sPort = SerialPort(Serial_Port, if autoBufferSize then bufferSize else userBufferSize, parity, receiver, baud);
    parameter Integer receiver = 1 "Set to be a receiver port";

  equation
    when initial() then
      bufferSize = if autoBufferSize then alignAtByteBoundary(pkgOut.autoPkgBitSize) else userBufferSize;
    end when;
    pkgOut.trigger = actTrigger "using inherited trigger";
    when pkgOut.trigger then
      pkgOut.dummy = Modelica_DeviceDrivers.Blocks.Communication.Internal.DummyFunctions.readSerial(
        sPort,
        pkgOut.pkg,
        time);
    end when;

    annotation (preferredView="info",
            Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,
              -100},{100,100}}), graphics={Text(extent={{-150,136},{150,96}},
              textString="%name"),         Text(extent={{-150,82},{150,42}},
            textString="%Serial_Port"),            Text(extent={{-152,-48},{148,-88}},
            textString="%baud")}), Documentation(info="<html>
<h4>Support for receiving datagrams over a serial port</h4>
<h4>Example</h4>
<p>
See <a href=\"modelica://Modelica_DeviceDrivers.Blocks.Examples.TestSerialPackager_SerialPort\"><code>TestSerialPackager_SerialPort</code></a>.
</p>
</html>"));
  end SerialPortReceive;

  block SerialPortSend
    "A block for sending serial datagrams using the serial interface"
    extends Modelica_DeviceDrivers.Utilities.Icons.SerialPortIcon;
    extends
      Modelica_DeviceDrivers.Blocks.Communication.Internal.PartialSampleTrigger;
    import Modelica_DeviceDrivers.Packaging.SerialPackager;
    import Modelica_DeviceDrivers.Communication.SerialPort;
    import Modelica_DeviceDrivers.Utilities.Types.SerialBaudRate;

    parameter Boolean autoBufferSize = true
      "true, buffer size is deduced automatically, otherwise set it manually."
      annotation(Dialog(group="Outgoing data"), choices(checkBox=true));
    parameter Integer userBufferSize=16*64
      "Buffer size of message data in bytes (if not deduced automatically)." annotation(Dialog(enable=not autoBufferSize, group="Outgoing data"));
    parameter String Serial_Port="/dev/ttyPS0" "SerialPort to sendData"
      annotation (Dialog(group="Outgoing data"));
    parameter SerialBaudRate baud = SerialBaudRate.B9600
      "Serial port baud rate"
       annotation (Dialog(group="Outgoing data"));
    parameter Integer parity = 0
      "set parity (0 - no parity, 1 - even, 2 - odd)"
       annotation (Dialog(group="Outgoing data"));

    Interfaces.PackageIn pkgIn annotation (
        Placement(transformation(
          extent={{-20,-20},{20,20}},
          rotation=270,
          origin={-108,0})));
  protected
    SerialPort sPort = SerialPort(Serial_Port, 0, parity, receiver, baud); // Creating port object from device
    Integer bufferSize;
    parameter Integer receiver = 0 "Set to be a sender port";
    Real dummy(start=0, fixed=true);
  equation
    when initial() then
      pkgIn.userPkgBitSize = if autoBufferSize then -1 else userBufferSize*8;
      pkgIn.autoPkgBitSize = 0;
      bufferSize = if autoBufferSize then Modelica_DeviceDrivers.Packaging.SerialPackager_.getBufferSize(pkgIn.pkg) else userBufferSize;
    end when;
    pkgIn.backwardTrigger = actTrigger "using inherited trigger";
    when pkgIn.trigger then
      dummy = Modelica_DeviceDrivers.Blocks.Communication.Internal.DummyFunctions.sendToSerial(
        sPort,
        pkgIn.pkg,
        bufferSize,
        pkgIn.dummy);
    end when;
    annotation (preferredView="info",
            Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,
              -100},{100,100}}), graphics={Text(extent={{-150,136},{150,96}},
              textString="%name"),         Text(extent={{-150,82},{150,42}},
            textString="%Serial_Port"),            Text(extent={{-154,-44},{146,-84}},
            textString="%baud")}), Documentation(info="<html>
<h4>Support for sending datagrams over a serial port</h4>
<h4>Example</h4>
<p>
See <a href=\"modelica://Modelica_DeviceDrivers.Blocks.Examples.TestSerialPackager_SerialPort\"><code>TestSerialPackager_SerialPort</code></a>.
</p>
</html>"));
  end SerialPortSend;

  block TCPIP_Client_IO "A client block for TCP/IP socket communication"
    import Modelica_DeviceDrivers;
    extends Modelica_DeviceDrivers.Utilities.Icons.BaseIcon;
    extends Modelica_DeviceDrivers.Utilities.Icons.TCPIPconnection;
    extends
      Modelica_DeviceDrivers.Blocks.Communication.Internal.PartialSampleTrigger;
    import Modelica_DeviceDrivers.Packaging.SerialPackager;
    import Modelica_DeviceDrivers.Communication.TCPIPSocketClient;

    parameter String IPAddress="127.0.0.1" "IP address of remote TCP/IP server";
    parameter Integer port=10002 "Port of the TCP/IP server";
    parameter Integer outputBufferSize=16*1024
      "Buffer size of message data in bytes." annotation(Dialog(group="Outgoing data"));
    parameter Integer inputBufferSize=16*1024
      "Buffer size of message data in bytes." annotation(Dialog(group="Incoming data"));
    Interfaces.PackageIn pkgIn annotation (Placement(transformation(
          extent={{-20,-20},{20,20}},
          rotation=270,
          origin={-108,0})));
    Interfaces.PackageOut pkgOut(pkg = SerialPackager(inputBufferSize), dummy(start=0, fixed=true))
                                       annotation (Placement(transformation(
          extent={{-20,-20},{20,20}},
          rotation=90,
          origin={108,0})));
  protected
    TCPIPSocketClient socket = TCPIPSocketClient();
    Boolean isConnected(start=false, fixed=true);
  equation
    when initial() then
      pkgIn.userPkgBitSize = outputBufferSize*8;
      pkgIn.autoPkgBitSize = 0;
      isConnected = Modelica_DeviceDrivers.Communication.TCPIPSocketClient_.connect_(socket, IPAddress, port);
    end when;
    pkgIn.backwardTrigger = actTrigger "using inherited trigger";
    pkgOut.trigger = pkgIn.backwardTrigger;
    when pkgIn.backwardTrigger then
      if isConnected then
        pkgOut.dummy = Modelica_DeviceDrivers.Blocks.Communication.Internal.DummyFunctions.readTCPIPServer(
          socket,
          pkgOut.pkg,
          inputBufferSize,
          Modelica_DeviceDrivers.Blocks.Communication.Internal.DummyFunctions.sendToTCPIPServer(
            socket,
            pkgIn.pkg,
            outputBufferSize,
            pkgIn.dummy));
      else
        pkgOut.dummy = pkgIn.dummy;
      end if;
    end when;
    annotation (preferredView="info",
            Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,
              -100},{100,100}}), graphics={Text(extent={{-150,136},{150,96}},
              textString="%name")}), Documentation(info="<html>
<p>Supports sending/receiving of packets to/from a server over TCP/IP.</p>
</html>"));
  end TCPIP_Client_IO;

  block LCMReceive "A block for receiving LCM datagrams"
    extends Modelica_DeviceDrivers.Utilities.Icons.BaseIcon;
    extends Modelica_DeviceDrivers.Utilities.Icons.LCMconnection;
    extends Modelica_DeviceDrivers.Blocks.Communication.Internal.PartialSampleTrigger;
    import Modelica_DeviceDrivers.Packaging.SerialPackager;
    import Modelica_DeviceDrivers.Packaging.alignAtByteBoundary;
    import Modelica_DeviceDrivers.Communication.LCM;
    import Modelica_DeviceDrivers.Utilities.Types.LCMProvider;
    parameter Boolean autoBufferSize = true
      "true, buffer size is deduced automatically, otherwise set it manually"
      annotation(Dialog(group="Incoming data"), choices(checkBox=true));
    parameter Integer userBufferSize=16*1024
      "Buffer size of message data in bytes (if not deduced automatically)" annotation(Dialog(enable=not autoBufferSize, group="Incoming data"));
    parameter LCMProvider provider=LCMProvider.UDPM "LCM network provider"
      annotation (Dialog(group="Incoming data"));
    parameter String address="224.0.0.0" "UDP multicast IP address or logfile name"
      annotation (Dialog(group="Incoming data", enable=(provider==LCMProvider.UDPM or provider==LCMProvider.FILE)));
    parameter Integer port=10001
      "UDP port (receivers must bind to the same port as the sender to receive multicast messages)"
      annotation (Dialog(group="Incoming data", enable=LCMProvider.UDPM));
    parameter String channel_recv="" "Channel name"
      annotation (Dialog(group="Incoming data"));
    parameter Integer queue_size=30
      "Maximum number of received messages that can be queued up"
      annotation (Dialog(group="Incoming data"));
    Interfaces.PackageOut pkgOut(pkg = SerialPackager(if autoBufferSize then bufferSize else userBufferSize), dummy(start=0, fixed=true))
      annotation (Placement(transformation(
          extent={{-20,-20},{20,20}},
          rotation=90,
          origin={108,0})));
  protected
    Integer bufferSize;
    parameter Integer receiver = 1 "Set to be a receiver port";
    LCM lcm = LCM(
      if provider == LCMProvider.UDPM then "udpm://" else if provider == LCMProvider.FILE then "file://" else "memq://",
      address, port, receiver, channel_recv, if autoBufferSize then bufferSize else userBufferSize, queue_size);
  equation
    when initial() then
      bufferSize = if autoBufferSize then alignAtByteBoundary(pkgOut.autoPkgBitSize) else userBufferSize;
    end when;
    pkgOut.trigger = actTrigger "using inherited trigger";
    when pkgOut.trigger then
      pkgOut.dummy = Modelica_DeviceDrivers.Blocks.Communication.Internal.DummyFunctions.readLCM(
        lcm,
        pkgOut.pkg,
        time);
    end when;
    annotation(defaultComponentName="lcmReceive", preferredView="info",
            Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,
              -100},{100,100}}), graphics={Text(extent={{-150,136},{150,96}},
              textString="%name")}), Documentation(info="<html>
<p>Supports receiving of Lightweight Communications and Marshalling (LCM) datagrams
(<a href=\"https://lcm-proj.github.io/\">https://lcm-proj.github.io/</a>).</p>
<h4>Remark regarding Linux</h4>
<p>
LCM requires a valid multicast route. If this is a Linux computer and it is
simply not connected to a network, the following commands are usually
sufficient as a temporary solution:
</p>
<pre>
sudo ifconfig lo multicast
sudo route add -net 224.0.0.0 netmask 240.0.0.0 dev lo
</pre>
</html>"));
  end LCMReceive;

  block LCMSend "A block for sending LCM datagrams"
    import Modelica_DeviceDrivers;
    extends Modelica_DeviceDrivers.Utilities.Icons.BaseIcon;
    extends Modelica_DeviceDrivers.Utilities.Icons.LCMconnection;
    extends Modelica_DeviceDrivers.Blocks.Communication.Internal.PartialSampleTrigger;
    import Modelica_DeviceDrivers.Packaging.SerialPackager;
    import Modelica_DeviceDrivers.Communication.LCM;
    import Modelica_DeviceDrivers.Utilities.Types.LCMProvider;

    parameter Boolean autoBufferSize = true
      "true, buffer size is deduced automatically, otherwise set it manually."
      annotation(Dialog(group="Outgoing data"), choices(checkBox=true));
    parameter Integer userBufferSize=16*1024
      "Buffer size of message data in bytes (if not deduced automatically)." annotation(Dialog(enable=not autoBufferSize, group="Outgoing data"));
    parameter LCMProvider provider=LCMProvider.UDPM "LCM network provider"
      annotation (Dialog(group="Outgoing data"));
    parameter String address="224.0.0.0" "UDP multicast IP address or logfile name"
      annotation (Dialog(group="Outgoing data", enable=(provider==LCMProvider.UDPM or provider==LCMProvider.FILE)));
    parameter Integer port=10002 "UDP port (all receivers must bind to the same port to receive the multicast messages)"
      annotation (Dialog(group="Outgoing data", enable=provider==LCMProvider.UDPM));
    parameter String channel_send="" "Channel name"
      annotation (Dialog(group="Outgoing data"));
    Interfaces.PackageIn pkgIn annotation (Placement(transformation(
          extent={{-20,-20},{20,20}},
          rotation=270,
          origin={-108,0})));
  protected
    parameter Integer receiver = 0 "Set to be a sender port";
    LCM lcm = LCM(
      if provider == LCMProvider.UDPM then "udpm://" else if provider == LCMProvider.FILE then "file://" else "memq://",
      address, port, receiver, "", 0, 0);
    Integer bufferSize;
    Real dummy(start=0, fixed=true);
  equation
    when initial() then
      pkgIn.userPkgBitSize = if autoBufferSize then -1 else userBufferSize*8;
      pkgIn.autoPkgBitSize = 0;
      bufferSize = if autoBufferSize then Modelica_DeviceDrivers.Packaging.SerialPackager_.getBufferSize(pkgIn.pkg) else userBufferSize;
    end when;
    pkgIn.backwardTrigger = actTrigger "using inherited trigger";
    when pkgIn.trigger then
      dummy = Modelica_DeviceDrivers.Blocks.Communication.Internal.DummyFunctions.sendToLCM(
        lcm,
        channel_send,
        pkgIn.pkg,
        bufferSize,
        pkgIn.dummy);
    end when;
    annotation(defaultComponentName="lcmSend", preferredView="info",
            Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,
              -100},{100,100}}), graphics={Text(extent={{-150,136},{150,96}},
              textString="%name")}), Documentation(info="<html>
<p>Supports sending of Lightweight Communications and Marshalling (LCM) datagrams.
(<a href=\"https://lcm-proj.github.io/\">https://lcm-proj.github.io/</a>)</p>
<h4>Remark regarding Linux</h4>
<p>
LCM requires a valid multicast route. If this is a Linux computer and it is
simply not connected to a network, the following commands are usually
sufficient as a temporary solution:
</p>
<pre>
sudo ifconfig lo multicast
sudo route add -net 224.0.0.0 netmask 240.0.0.0 dev lo
</pre>
</html>"));
  end LCMSend;

  block MQTTReceive "A block for receiving MQTT datagrams"
    extends Modelica_DeviceDrivers.Utilities.Icons.BaseIcon;
    extends Modelica_DeviceDrivers.Utilities.Icons.MQTTconnection;
    extends Modelica_DeviceDrivers.Blocks.Communication.Internal.PartialSampleTrigger;
    import Modelica_DeviceDrivers.Packaging.SerialPackager;
    import Modelica_DeviceDrivers.Packaging.alignAtByteBoundary;
    import Modelica_DeviceDrivers.Communication.MQTT;
    import Modelica_DeviceDrivers.Utilities.Types.MQTTProvider;
    import Modelica_DeviceDrivers.Utilities.Types.MQTTVersion;
    import Modelica_DeviceDrivers.Utilities.Types.MQTTTracing;
    import Modelica_DeviceDrivers.Utilities.Types.TLSVersion;
    import Modelica_DeviceDrivers.Utilities.Functions.getMACAddress;
    parameter Boolean autoBufferSize = true
      "true, buffer size is deduced automatically, otherwise set it manually"
      annotation(Dialog(group="Incoming data"), choices(checkBox=true));
    parameter Integer userBufferSize=16*1024
      "Buffer size of message data in bytes (if not deduced automatically)"
      annotation(Dialog(enable=not autoBufferSize, group="Incoming data"));
    parameter MQTTProvider provider = MQTTProvider.TCP "MQTT network protocol"
      annotation(Dialog(group="Incoming data", groupImage="modelica://Modelica_DeviceDrivers/Resources/Images/pahologo.png"));
    parameter MQTTVersion protocolVersion = MQTTVersion.DEFAULT "MQTT network protocol version"
      annotation(Dialog(group="Incoming data"));
    parameter String address = "localhost" "IP address"
      annotation(Dialog(group="Incoming data"));
    parameter Integer port = 1883 "Port"
      annotation(Dialog(group="Incoming data"));
    parameter String channel_recv = "" "Channel name"
      annotation(Dialog(group="Incoming data"));
    parameter Integer QoS(min=0, max=2) = 1 "Quality of service"
      annotation(Dialog(group="Incoming data"), choices(choice=0 "At most once", choice=1 "At least once", choice=2 "Exactly once"));
    parameter String clientID = "recv-" + getMACAddress() "Unique client identifier"
      annotation(Dialog(group="Server connection", tab="Advanced"));
    parameter Integer keepAliveInterval = 60 "Maximum time (in seconds) that should pass without communication between the client and the server"
      annotation(Dialog(group="Server connection", tab="Advanced"));
    parameter Integer connectTimeout = 30 "Connection timeout (in seconds)"
      annotation(Dialog(group="Server connection", tab="Advanced"));
    parameter Integer disconnectTimeout = 10 "Disconnection timeout (in seconds)"
      annotation(Dialog(group="Server connection", tab="Advanced"));
    parameter Boolean cleanSession = true "=true, if session state at connect and disconnect is to be discarded"
      annotation(Dialog(group="Server connection", tab="Advanced"), choices(checkBox=true));
    parameter Boolean reliable = true "=true, if a published message must be completed (acknowledgements received) before another message can be sent"
      annotation(Dialog(group="Server connection", tab="Advanced"), choices(checkBox=true));
    parameter String userName = "" "User name for authentication and authorisation"
      annotation(Dialog(group="Server connection", tab="Advanced", enable=protocolVersion<>MQTTVersion.V31));
    parameter String password = "" "Password for authentication and authorisation"
      annotation(Dialog(group="Server connection", tab="Advanced", enable=protocolVersion<>MQTTVersion.V31));
    parameter Boolean certAuth = true "=true, if verification of the server certificate is enabled"
      annotation(Dialog(group="Transport Layer Security", tab="Advanced", enable=provider==MQTTProvider.SSL or provider==MQTTProvider.WSS), choices(checkBox=true));
    parameter Boolean verify = false "=true, if post-connect checks are enabled"
      annotation(Dialog(group="Transport Layer Security", tab="Advanced", enable=provider==MQTTProvider.SSL or provider==MQTTProvider.WSS), choices(checkBox=true));
    parameter TLSVersion sslVersion = TLSVersion.DEFAULT "SSL/TLS version"
      annotation(Dialog(group="Transport Layer Security", tab="Advanced", enable=provider==MQTTProvider.SSL or provider==MQTTProvider.WSS));
    parameter String trustStore = "" "Public digital certificates trusted by the client"
      annotation(Dialog(group="Transport Layer Security", tab="Advanced", enable=provider==MQTTProvider.SSL or provider==MQTTProvider.WSS,
        loadSelector(filter="Certificate files (*.cer;*.cert;*.crt;*.pem)",
        caption="Open file")));
    parameter String keyStore = "" "Public certificate chain of the client (may also include the private key of the client)"
      annotation(Dialog(group="Transport Layer Security", tab="Advanced", enable=provider==MQTTProvider.SSL or provider==MQTTProvider.WSS,
        loadSelector(filter="Certificate files (*.cer;*.cert;*.crt;*.pem)",
        caption="Open file")));
    parameter String privateKey = "" "Private key of the client (may be empty if already included in the keyStore)"
      annotation(Dialog(group="Transport Layer Security", tab="Advanced", enable=provider==MQTTProvider.SSL or provider==MQTTProvider.WSS,
        loadSelector(filter="Certificate files (*.key;*.pem)",
        caption="Open file")));
    parameter MQTTTracing traceLevel = MQTTTracing.DEFAULT "MQTT client tracing"
      annotation(Dialog(group="Tracing", tab="Advanced"));
    Interfaces.PackageOut pkgOut(pkg = SerialPackager(if autoBufferSize then bufferSize else userBufferSize), dummy(start=0, fixed=true))
      annotation (Placement(transformation(
          extent={{-20,-20},{20,20}},
          rotation=90,
          origin={108,0})));
  protected
    Integer bufferSize;
    parameter Boolean receiver = true "Set to be a receiver port";
    MQTT mqtt = MQTT(
      if provider == MQTTProvider.TCP then "tcp://" else if provider == MQTTProvider.SSL then "ssl://" else if provider == MQTTProvider.WS then "ws://" else "wss://",
      address, port, receiver, channel_recv, if autoBufferSize then bufferSize else userBufferSize, QoS, clientID, userName, password, trustStore, keyStore, privateKey, keepAliveInterval, cleanSession, reliable, connectTimeout,
      if protocolVersion == MQTTVersion.V5 then 5 else if protocolVersion == MQTTVersion.V311 then 4 else if protocolVersion == MQTTVersion.V31 then 3 else 0, disconnectTimeout, certAuth, verify,
      if sslVersion == TLSVersion.V12 then 3 else if sslVersion == TLSVersion.V11 then 2 else if sslVersion == TLSVersion.V10 then 1 else 0,
      if traceLevel == MQTTTracing.FATAL then 7 else if traceLevel == MQTTTracing.SEVERE then 6 else if traceLevel == MQTTTracing.ERROR then 5 else if traceLevel == MQTTTracing.PROTOCOL then 4 else if traceLevel == MQTTTracing.MINIMUM then 3 else if traceLevel == MQTTTracing.MEDIUM then 2 else if traceLevel == MQTTTracing.MAXIMUM then 1 else 0) "MQTT external object";
  equation
    when initial() then
      bufferSize = if autoBufferSize then alignAtByteBoundary(pkgOut.autoPkgBitSize) else userBufferSize;
    end when;
    pkgOut.trigger = actTrigger "using inherited trigger";
    when pkgOut.trigger then
      pkgOut.dummy = Modelica_DeviceDrivers.Blocks.Communication.Internal.DummyFunctions.readMQTT(
        mqtt,
        pkgOut.pkg,
        time);
    end when;
    annotation(defaultComponentName="mqttReceive", preferredView="info",
            Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,
              -100},{100,100}}), graphics={Text(extent={{-150,136},{150,96}},
              textString="%name")}), Documentation(info="<html>
<p>Supports receiving of Message Queue Telemetry Transport (MQTT) datagrams
(<a href=\"http://mqtt.org/\">http://mqtt.org/</a>) by wrapping the <a href=\"https://github.com/eclipse/paho.mqtt.c\">Eclipse Paho MQTT C client</a>.</p>
<p><img src=\"modelica://Modelica_DeviceDrivers/Resources/Images/pahologo.png\"></p>
</html>"));
  end MQTTReceive;

  block MQTTSend "A block for sending MQTT datagrams"
    extends Modelica_DeviceDrivers.Utilities.Icons.BaseIcon;
    extends Modelica_DeviceDrivers.Utilities.Icons.MQTTconnection;
    extends Modelica_DeviceDrivers.Blocks.Communication.Internal.PartialSampleTrigger;
    import Modelica_DeviceDrivers.Packaging.SerialPackager;
    import Modelica_DeviceDrivers.Communication.MQTT;
    import Modelica_DeviceDrivers.Utilities.Types.MQTTProvider;
    import Modelica_DeviceDrivers.Utilities.Types.MQTTVersion;
    import Modelica_DeviceDrivers.Utilities.Types.MQTTTracing;
    import Modelica_DeviceDrivers.Utilities.Types.TLSVersion;
    import Modelica_DeviceDrivers.Utilities.Functions.getMACAddress;
    parameter Boolean autoBufferSize = true
      "true, buffer size is deduced automatically, otherwise set it manually."
      annotation(Dialog(group="Outgoing data"), choices(checkBox=true));
    parameter Integer userBufferSize=16*1024
      "Buffer size of message data in bytes (if not deduced automatically)." annotation(Dialog(enable=not autoBufferSize, group="Outgoing data"));
    parameter MQTTProvider provider = MQTTProvider.TCP "MQTT network protocol"
      annotation(Dialog(group="Outgoing data", groupImage="modelica://Modelica_DeviceDrivers/Resources/Images/pahologo.png"));
    parameter MQTTVersion protocolVersion = MQTTVersion.DEFAULT "MQTT network protocol version"
      annotation(Dialog(group="Outgoing data"));
    parameter String address = "localhost" "IP address"
      annotation(Dialog(group="Outgoing data"));
    parameter Integer port = 1883 "Port"
      annotation(Dialog(group="Outgoing data"));
    parameter String channel_send = "" "Channel name"
      annotation(Dialog(group="Outgoing data"));
    parameter Integer QoS(min=0, max=2) = 1 "Quality of service"
      annotation(Dialog(group="Outgoing data"), choices(choice=0 "At most once", choice=1 "At least once", choice=2 "Exactly once"));
    parameter Integer deliveryTimeout = 10 "Delivery timeout (in seconds)"
      annotation(Dialog(group="Outgoing data", enable=QoS>0));
    parameter Boolean retained = false "Retained flag"
      annotation(Dialog(group="Outgoing data"), choices(checkBox=true));
    parameter String clientID = "send-" + getMACAddress() "Unique client identifier"
      annotation(Dialog(group="Server connection", tab="Advanced"));
    parameter Integer keepAliveInterval = 60 "Maximum time (in seconds) that should pass without communication between the client and the server"
      annotation(Dialog(group="Server connection", tab="Advanced"));
    parameter Integer connectTimeout = 30 "Connection timeout (in seconds)"
      annotation(Dialog(group="Server connection", tab="Advanced"));
    parameter Integer disconnectTimeout = 10 "Disconnection timeout (in seconds)"
      annotation(Dialog(group="Server connection", tab="Advanced"));
    parameter Boolean cleanSession = true "=true, if session state at connect and disconnect is to be discarded"
      annotation(Dialog(group="Server connection", tab="Advanced"), choices(checkBox=true));
    parameter Boolean reliable = true "=true, if a published message must be completed (acknowledgements received) before another message can be sent"
      annotation(Dialog(group="Server connection", tab="Advanced"), choices(checkBox=true));
    parameter String userName = "" "User name for authentication and authorisation"
      annotation(Dialog(group="Server connection", tab="Advanced", enable=protocolVersion<>MQTTVersion.V31));
    parameter String password = "" "Password for authentication and authorisation"
      annotation(Dialog(group="Server connection", tab="Advanced", enable=protocolVersion<>MQTTVersion.V31));
    parameter Boolean certAuth = true "=true, if verification of the server certificate is enabled"
      annotation(Dialog(group="Transport Layer Security", tab="Advanced", enable=provider==MQTTProvider.SSL or provider==MQTTProvider.WSS), choices(checkBox=true));
    parameter Boolean verify = false "=true, if post-connect checks are enabled"
      annotation(Dialog(group="Transport Layer Security", tab="Advanced", enable=provider==MQTTProvider.SSL or provider==MQTTProvider.WSS), choices(checkBox=true));
    parameter TLSVersion sslVersion = TLSVersion.DEFAULT "SSL/TLS version"
      annotation(Dialog(group="Transport Layer Security", tab="Advanced", enable=provider==MQTTProvider.SSL or provider==MQTTProvider.WSS));
    parameter String trustStore = "" "Public digital certificates trusted by the client"
      annotation(Dialog(group="Transport Layer Security", tab="Advanced", enable=provider==MQTTProvider.SSL or provider==MQTTProvider.WSS,
        loadSelector(filter="Certificate files (*.cer;*.cert;*.crt;*.pem)",
        caption="Open file")));
    parameter String keyStore = "" "Public certificate chain of the client (may also include the private key of the client)"
      annotation(Dialog(group="Transport Layer Security", tab="Advanced", enable=provider==MQTTProvider.SSL or provider==MQTTProvider.WSS,
        loadSelector(filter="Certificate files (*.cer;*.cert;*.crt;*.pem)",
        caption="Open file")));
    parameter String privateKey = "" "Private key of the client (may be empty if already included in the keyStore)"
      annotation(Dialog(group="Transport Layer Security", tab="Advanced", enable=provider==MQTTProvider.SSL or provider==MQTTProvider.WSS,
        loadSelector(filter="Certificate files (*.key;*.pem)",
        caption="Open file")));
    parameter MQTTTracing traceLevel = MQTTTracing.DEFAULT "MQTT client tracing"
      annotation(Dialog(group="Tracing", tab="Advanced"));
    Interfaces.PackageIn pkgIn annotation (Placement(transformation(
          extent={{-20,-20},{20,20}},
          rotation=270,
          origin={-108,0})));
  protected
    Integer bufferSize;
    Real dummy(start=0, fixed=true);
    parameter Boolean receiver = false "Set to be a sender port";
    MQTT mqtt = MQTT(
      if provider == MQTTProvider.TCP then "tcp://" else if provider == MQTTProvider.SSL then "ssl://" else if provider == MQTTProvider.WS then "ws://" else "wss://",
      address, port, receiver, channel_send, 0, QoS, clientID, userName, password, trustStore, keyStore, privateKey, keepAliveInterval, cleanSession, reliable, connectTimeout,
      if protocolVersion == MQTTVersion.V5 then 5 else if protocolVersion == MQTTVersion.V311 then 4 else if protocolVersion == MQTTVersion.V31 then 3 else 0, disconnectTimeout, certAuth, verify,
      if sslVersion == TLSVersion.V12 then 3 else if sslVersion == TLSVersion.V11 then 2 else if sslVersion == TLSVersion.V10 then 1 else 0,
      if traceLevel == MQTTTracing.FATAL then 7 else if traceLevel == MQTTTracing.SEVERE then 6 else if traceLevel == MQTTTracing.ERROR then 5 else if traceLevel == MQTTTracing.PROTOCOL then 4 else if traceLevel == MQTTTracing.MINIMUM then 3 else if traceLevel == MQTTTracing.MEDIUM then 2 else if traceLevel == MQTTTracing.MAXIMUM then 1 else 0) "MQTT external object";
  equation
    when initial() then
      pkgIn.userPkgBitSize = if autoBufferSize then -1 else userBufferSize*8;
      pkgIn.autoPkgBitSize = 0;
      bufferSize = if autoBufferSize then Modelica_DeviceDrivers.Packaging.SerialPackager_.getBufferSize(pkgIn.pkg) else userBufferSize;
    end when;
    pkgIn.backwardTrigger = actTrigger "using inherited trigger";
    when pkgIn.trigger then
      dummy = Modelica_DeviceDrivers.Blocks.Communication.Internal.DummyFunctions.sendToMQTT(
        mqtt,
        channel_send,
        pkgIn.pkg,
        retained,
        deliveryTimeout,
        bufferSize,
        pkgIn.dummy);
    end when;
    annotation(defaultComponentName="mqttSend", preferredView="info",
            Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,
              -100},{100,100}}), graphics={Text(extent={{-150,136},{150,96}},
              textString="%name")}), Documentation(info="<html>
<p>Supports sending of Message Queue Telemetry Transport (MQTT) datagrams
(<a href=\"http://mqtt.org/\">http://mqtt.org/</a>) by wrapping the <a href=\"https://github.com/eclipse/paho.mqtt.c\">Eclipse Paho MQTT C client</a>.</p>
<p><img src=\"modelica://Modelica_DeviceDrivers/Resources/Images/pahologo.png\"></p>
</html>"));
  end MQTTSend;

  package SoftingCAN
    "Support for Softing's CAN interfaces utilizing their CANL2 API library"
    extends Modelica.Icons.Package;

    block SoftingCANConfig "Configuration for a softing CAN interface"
      extends Modelica_DeviceDrivers.Utilities.Icons.BaseIcon;
    extends Modelica_DeviceDrivers.Utilities.Icons.BusIcon;
      import Modelica_DeviceDrivers.Utilities.Types.BaudRate;
      import Modelica_DeviceDrivers.Communication.SoftingCAN;
    parameter String deviceName = "CANusb_1" "Name of CAN device";
    parameter BaudRate baudRate=BaudRate.kBaud500 "CAN baud rate";
    parameter Integer nu(min=0)=0 "Number of input connections"
      annotation(Dialog(connectorSizing=true), HideResult=true);

    Modelica_DeviceDrivers.Blocks.Interfaces.SoftingCANOut softingCANBus[nu]
      annotation (Placement(
            transformation(
            extent={{-20,-20},{20,20}},
            rotation=90,
            origin={108,0})));

    protected
      Modelica_DeviceDrivers.Communication.SoftingCAN
                 softingCAN = SoftingCAN(deviceName, baudRate);
    initial equation
      Modelica.Utilities.Streams.print("SoftingCAN ("+deviceName+"): Total number of defined messages: "+String(sum(softingCANBus.dummy))+".");
      Modelica_DeviceDrivers.Blocks.Communication.SoftingCAN.Internal.startChipDummy(
         softingCAN, sum(softingCANBus.dummy));
    equation
      softingCANBus.softingCAN = fill(softingCAN, nu);
      annotation (Icon(graphics={
            Text(
              extent={{-98,72},{94,46}},
              textString="%deviceName")}),
        Documentation(info="<html>
<h4>Support for Softing CAN bus</h4>
<p><b>Please, read the package information for <a href=\"modelica://Modelica_DeviceDrivers.Blocks.Communication.SoftingCAN\"><code>SoftingCAN</code></a> first!</b></p>
<h4>Example</h4>
<p>
See <a href=\"modelica://Modelica_DeviceDrivers.Blocks.Examples.TestSerialPackager_SoftingCAN\"><code>TestSerialPackager_SoftingCAN</code></a>.
</p>
</html>"));
    end SoftingCANConfig;

    block SoftingReadMessage "Set up a message for receiving data"
      import Modelica_DeviceDrivers;
      extends Modelica_DeviceDrivers.Blocks.Interfaces.PartialSoftingCANMessage;
      extends
        Modelica_DeviceDrivers.Blocks.Communication.Internal.PartialSampleTrigger;
      import Modelica_DeviceDrivers.Communication.SoftingCAN;
      import Modelica_DeviceDrivers.Utilities.Types;
      import Modelica_DeviceDrivers.Packaging.SerialPackager;
      import SI = Modelica.SIunits;
      parameter Integer ident(min=0) "Identifier of CAN message (CAN Id)";
      Interfaces.PackageOut pkgOut(pkg = SerialPackager(8), dummy(start=0, fixed=true))
        annotation (Placement(transformation(extent={{-20,-128},{20,-88}})));
    protected
      Integer objectNumber;
    initial equation
      objectNumber = Modelica_DeviceDrivers.Communication.SoftingCAN_.defineObject(
        softingCANBus.softingCAN,
        ident,
        Types.TransmissionType.standardReceive);
      softingCANBus.dummy = 1;
    equation
      pkgOut.trigger = actTrigger "using inherited trigger";
      when pkgOut.trigger then
        objectNumber = pre(objectNumber);
        pkgOut.dummy = Modelica_DeviceDrivers.Blocks.Communication.SoftingCAN.Internal.readRcvDataDummy(
          softingCANBus.softingCAN,
          objectNumber,
          pkgOut.pkg,
          time);

        softingCANBus.dummy = pre(softingCANBus.dummy);
      end when;

      annotation (defaultComponentName="rxMessage",
      Icon(graphics={Text(
              extent={{-98,54},{98,26}},
              textString="Rx id: %ident"),
            Text(
              extent={{-160,24},{160,-6}},
              textString="(%startTime, %sampleTime) s")}),
        Documentation(info="<html>
<h4>Support for Softing CAN bus</h4>
<p><b>Please, read the package information for <a href=\"modelica://Modelica_DeviceDrivers.Blocks.Communication.SoftingCAN\"><code>SoftingCAN</code></a> first!</b></p>
<h4>Example</h4>
<p>
See <a href=\"modelica://Modelica_DeviceDrivers.Blocks.Examples.TestSerialPackager_SoftingCAN\"><code>TestSerialPackager_SoftingCAN</code></a>.
</p>
</html>"));
    end SoftingReadMessage;

    block SoftingWriteMessage "Set up a message for transmitting data"
      import Modelica_DeviceDrivers;
      extends Modelica_DeviceDrivers.Blocks.Interfaces.PartialSoftingCANMessage;
      extends
        Modelica_DeviceDrivers.Blocks.Communication.Internal.PartialSampleTrigger;
      import Modelica_DeviceDrivers.Communication.SoftingCAN;
      import Modelica_DeviceDrivers.Packaging.SerialPackager;
      import Modelica_DeviceDrivers.Utilities.Types;
      import SI = Modelica.SIunits;
      parameter Integer ident(min=0) "Identifier of CAN message (CAN Id)";
      parameter Integer dlc(min=0,max=8) = 8
        "Data length code (payload of data in bytes, max=8)";
      Interfaces.PackageIn pkgIn
        annotation (Placement(transformation(extent={{-20,-128},{20,-88}})));
    protected
      Integer objectNumber;
      Real dummy(start=0, fixed=true);
    initial equation
      objectNumber =  Modelica_DeviceDrivers.Communication.SoftingCAN_.defineObject(
        softingCANBus.softingCAN,
        ident,
        Types.TransmissionType.standardTransmit);
      softingCANBus.dummy = 1;
    equation
      when initial() then
        pkgIn.userPkgBitSize = dlc*8;
        pkgIn.autoPkgBitSize = 0;
      end when;

      pkgIn.backwardTrigger = actTrigger "using inherited trigger";
      when pkgIn.trigger then
        objectNumber = pre(objectNumber);
        dummy = Modelica_DeviceDrivers.Blocks.Communication.SoftingCAN.Internal.writeObjectDummy(
          softingCANBus.softingCAN,
          objectNumber,
          dlc,
          pkgIn.pkg,
          pkgIn.dummy);

        softingCANBus.dummy = pre(softingCANBus.dummy);
      end when;
      annotation (defaultComponentName="txMessage",
      Icon(graphics={
            Text(
              extent={{-90,54},{96,24}},
              textString="Tx id: %ident"),
            Text(
              extent={{-160,24},{160,-6}},
              textString="(%startTime, %sampleTime) s")}),
        Documentation(info="<html>
<h4>Support for Softing CAN bus</h4>
<p><b>Please, read the package information for <a href=\"modelica://Modelica_DeviceDrivers.Blocks.Communication.SoftingCAN\"><code>SoftingCAN</code></a> first!</b></p>
<h4>Example</h4>
<p>
See <a href=\"modelica://Modelica_DeviceDrivers.Blocks.Examples.TestSerialPackager_SoftingCAN\"><code>TestSerialPackager_SoftingCAN</code></a>.
</p>
</html>"));
    end SoftingWriteMessage;

    package Internal
      extends Modelica.Icons.InternalPackage;
      encapsulated function startChipDummy
        import Modelica_DeviceDrivers.Communication.SoftingCAN;
        import Modelica_DeviceDrivers;
        input Modelica_DeviceDrivers.Communication.SoftingCAN
                       softingCAN "Handle for device";
        input Real dummy;
      algorithm
        Modelica_DeviceDrivers.Communication.SoftingCAN_.startChip(softingCAN);
      end startChipDummy;

      encapsulated function readRcvDataDummy
        "Write object (CAN message) to transmit buffer"
        import Modelica_DeviceDrivers.Communication.SoftingCAN;
        import Modelica_DeviceDrivers;
        import Modelica_DeviceDrivers.Packaging.SerialPackager;

        input SoftingCAN softingCAN "Handle for device";
        input Integer objectNumber
          "Object number of message (from defineObject(..))";
        input SerialPackager pkg;
        input Real dummy;
        output Real dummy2;
      algorithm
        Modelica_DeviceDrivers.Communication.SoftingCAN_.readRcvData(softingCAN, objectNumber, pkg);
        dummy2 := dummy;
      end readRcvDataDummy;

      encapsulated function writeObjectDummy
        "Write object (CAN message) to transmit buffer"
        import Modelica_DeviceDrivers.Communication.SoftingCAN;
        import Modelica_DeviceDrivers;
        import Modelica_DeviceDrivers.Packaging.SerialPackager;

        input SoftingCAN softingCAN "Handle for device";
        input Integer objectNumber
          "Object number of message (from defineObject(..))";
        input Integer dataLength "Length of message in bytes";
        input SerialPackager pkg;
        input Real dummy;
        output Real dummy2;
      algorithm
        Modelica_DeviceDrivers.Communication.SoftingCAN_.writeObject(softingCAN, objectNumber, dataLength, pkg);
        dummy2 := dummy;
      end writeObjectDummy;
    end Internal;
    annotation (preferredView="info",
    Documentation(info="<html>
<h4>Prototypical support for Softing CAN interfaces</h4>
Please note, that the support for CAN is considered <b>prototypical</b>. Even more than for the other elements in this library there might be severe bugs in it and you use it on <b>your own risk</b>. Additionally, the API of the blocks is more likely to change in the future. So please, refrain from using it for building your next nuclear power plant or fly-by-wire system ...
<h4>System Requirements</h4>
<p>
The needed files are freely available from Softing, however the
corresponding license sets limits on the distributability of the
files. Consequently, the files are not distributed with this library.
</p>
<p>
There are exist drivers for Windows and Linux. However, the Linux package only supports very old Linux kernels (at least that was the case for June, 2012). Because of this, Softing CAN interfaces are currently only supported for Windows.
</p>
<p>
Please download and install the Softing drivers including the CAN Layer2 API from Softing
(e.g., start at <a href=\"http://industrial.softing.com/\">http://industrial.softing.com/</a> and click your way through).
</p>
<p>
After installation of the software driver package available from Softing, please copy the files from
\"$PATH_TO_SOFTING_API\\APIDLL\\*\" into the directory
<code>$PATH_TO_MODELICA_DEVICEDRIVERS\\Modelica_DeviceDrivers\\Resources\\thirdParty\\softing</code> (on my computer the Softing installation path
is \"C:\\Program Files (x86)\\Softing\\CAN\\CAN Layer2 V5.16\\APIDLL\"),
so that you end up with the following directory tree:
</p>
<pre>
.\\win32\\canL2.dll
.\\win32\\canL2.lib
.\\win32\\CANusbM.dll
.\\win64\\canL2_64.dll
.\\win64\\canL2_64.lib
.\\win64\\CANusbM.dll
.\\Can_def.h
.\\CANL2.h
</pre>

<p>
Finally, note that in order to translate and execute Modelica models utilizing this API it is necessary that the
corresponding .lib and .dll files are found at compile and runtime. Preferred way to ensure this:
</p>
<p>
Copy the <code>*.dll</code> and <code>*.lib</code> for your architecture into your simulation directory (note that working on a 64bit Windows does
not necessary mean that your Modelica tool compiles 64bit binaries, i.e., if in doubt just try both). Additionally, rename
<code>canL2_64.*</code> to <code>canL2.*</code> if using the 64bit libraries.
</p>

</html>"));
  end SoftingCAN;

  package SocketCAN
    "ALPHA feature. Support for the Linux Controller Area Network Protocol Family (aka Socket CAN)"
    extends Modelica.Icons.Package;
    record SocketCANConfig "Open socket to specified CAN interface"
    extends Modelica_DeviceDrivers.Utilities.Icons.SocketCANRecordIcon;
      import Modelica_DeviceDrivers.Communication.SocketCAN;
      parameter String ifrName = "vcan0"
        "CAN interface name (as displayed by ifconfig)";
      final parameter SocketCAN dh = SocketCAN(ifrName) "SocketCAN handle";
      annotation (preferredView="info",
              Icon(graphics={
                     Text(
              extent={{-98,70},{98,42}},
              textString="%ifrName")}),
        Documentation(info="<html>
<h4>Support for Linux Socket CAN bus</h4>
<p><b>Please, read the package information for <a href=\"modelica://Modelica_DeviceDrivers.Blocks.Communication.SocketCAN\"><code>SocketCAN</code></a> first!</b></p>
<h4>Example</h4>
<p>
See <a href=\"modelica://Modelica_DeviceDrivers.Blocks.Examples.TestSerialPackager_SocketCAN\"><code>TestSerialPackager_SocketCAN</code></a>.
</p>
</html>"));
    end SocketCANConfig;

    block ReadMessage "Set up a message for receiving data"
      extends Modelica_DeviceDrivers.Utilities.Icons.BaseIcon;
      extends Modelica_DeviceDrivers.Utilities.Icons.SocketCANBlockIcon;
      extends
        Modelica_DeviceDrivers.Blocks.Communication.Internal.PartialSampleTrigger;
      import Modelica_DeviceDrivers;
      import Modelica_DeviceDrivers.Communication.SocketCAN;
      import Modelica_DeviceDrivers.Packaging.SerialPackager;
      parameter SocketCANConfig config
        "Socket CAN configuration (socket) to use for this block" annotation (__Dymola_componentsMatching=true);
      parameter Integer can_id(min=0) "Identifier of CAN message (CAN Id)";
      parameter Integer can_dlc(min=0,max=8) = 8
        "Data length code (payload of data in bytes, max=8)";
      Interfaces.PackageOut pkgOut(pkg = SerialPackager(can_dlc), dummy(start=0, fixed=true))
        annotation (Placement(transformation(extent={{-20,-20},{20,20}},
            rotation=90,
            origin={108,0})));
    initial equation
      Modelica_DeviceDrivers.Communication.SocketCAN_.defineObject(
        config.dh,
        can_id,
        can_dlc);
    equation
      pkgOut.trigger = actTrigger "using inherited trigger";
      when pkgOut.trigger then
        pkgOut.dummy = Modelica_DeviceDrivers.Blocks.Communication.SocketCAN.Internal.readObjectDummy(
          config.dh,
          can_id,
          can_dlc,
          pkgOut.pkg,
          time);
    end when;

      annotation (preferredView="info",
      defaultComponentName="rxMessage",
      Icon(graphics={Text(
              extent={{-98,86},{98,58}},
              textString="Rx id: %can_id"),
            Text(
              extent={{-92,-56},{36,-88}},
              textString="(%startTime, %sampleTime) s",
              horizontalAlignment=TextAlignment.Left)}),
        Documentation(info="<html>
<h4>Support for Linux Socket CAN interface</h4>
<p><b>Please, read the package information for <a href=\"modelica://Modelica_DeviceDrivers.Blocks.Communication.SocketCAN\"><code>SocketCAN</code></a> first!</b></p>
<h4>Example</h4>
<p>
See <a href=\"modelica://Modelica_DeviceDrivers.Blocks.Examples.TestSerialPackager_SocketCAN\"><code>TestSerialPackager_SocketCAN</code></a>.
</p>
</html>"));
    end ReadMessage;

    block WriteMessage "Set up a message for transmitting data"
      import Modelica_DeviceDrivers;
      extends Modelica_DeviceDrivers.Utilities.Icons.BaseIcon;
      extends Modelica_DeviceDrivers.Utilities.Icons.SocketCANBlockIcon;
      extends
        Modelica_DeviceDrivers.Blocks.Communication.Internal.PartialSampleTrigger;
      import Modelica_DeviceDrivers.Communication.SocketCAN;
      import Modelica_DeviceDrivers.Packaging.SerialPackager;
      parameter SocketCANConfig config
        "Socket CAN configuration (socket) to use for this block" annotation (__Dymola_componentsMatching=true);
      parameter Integer can_id(min=0) "Identifier of CAN message (CAN Id)";
      parameter Integer can_dlc(min=0,max=8) = 8
        "Data length code (payload of data in bytes, max=8)";
      Interfaces.PackageIn pkgIn
        annotation (Placement(transformation(extent={{-20,-20},{20,20}},
            rotation=-90,
            origin={-108,0})));
    protected
      Real dummy(start=0, fixed=true);
    equation
      when initial() then
        pkgIn.userPkgBitSize = can_dlc*8;
        pkgIn.autoPkgBitSize = 0;
        Modelica_DeviceDrivers.Communication.SocketCAN_.defineObject(
                               config.dh, can_id, can_dlc);
      end when;

      pkgIn.backwardTrigger = actTrigger "using inherited trigger";
      when pkgIn.trigger then
        dummy = Modelica_DeviceDrivers.Blocks.Communication.SocketCAN.Internal.writeDummy(
          config.dh,
          can_id,
          can_dlc,
          pkgIn.pkg,
          pkgIn.dummy);
      end when;
      annotation (preferredView="info",
      defaultComponentName="txMessage",
      Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
                100}}),
           graphics={
            Text(
              extent={{-90,84},{96,54}},
              textString="Tx id: %can_id"),
            Text(
              extent={{-92,-58},{36,-90}},
              textString="(%startTime, %sampleTime) s",
              horizontalAlignment=TextAlignment.Left)}),
        Documentation(info="<html>
<h4>Support for Linux Socket CAN interface</h4>
<p><b>Please, read the package information for <a href=\"modelica://Modelica_DeviceDrivers.Blocks.Communication.SocketCAN\"><code>SocketCAN</code></a> first!</b></p>
<h4>Example</h4>
<p>
See <a href=\"modelica://Modelica_DeviceDrivers.Blocks.Examples.TestSerialPackager_SocketCAN\"><code>TestSerialPackager_SocketCAN</code></a>.
</p>
</html>"));
    end WriteMessage;

    package Internal
      extends Modelica.Icons.InternalPackage;

      encapsulated function readObjectDummy
        "Read CAN frame/message from socket"
        import Modelica_DeviceDrivers.Communication.SocketCAN;
        import Modelica_DeviceDrivers;
        import Modelica_DeviceDrivers.Packaging.SerialPackager;

        input SocketCAN socketCAN;
        input Integer can_id "CAN frame identifier";
        input Integer can_dlc(min=0,max=8)
          " length of data in bytes (min=0, max=8)";
        input SerialPackager pkg;
        input Real dummy;
        output Real dummy2;
      algorithm
        Modelica_DeviceDrivers.Communication.SocketCAN_.readObject(socketCAN, can_id, can_dlc, pkg);
        dummy2 := dummy;
      end readObjectDummy;

      encapsulated function writeDummy "Write CAN frame/message to socket"
        import Modelica_DeviceDrivers.Communication.SocketCAN;
        import Modelica_DeviceDrivers;
        import Modelica_DeviceDrivers.Packaging.SerialPackager;

        input SocketCAN socketCAN;
        input Integer can_id "CAN frame identifier";
        input Integer can_dlc(min=0,max=8)
          "length of data in bytes (min=0, max=8)";
        input SerialPackager pkg;
        input Real dummy;
        output Real dummy2;
      algorithm
        Modelica_DeviceDrivers.Communication.SocketCAN_.write(socketCAN, can_id, can_dlc, pkg);
        dummy2 := dummy;
      end writeDummy;
    end Internal;
    annotation (preferredView="info",Documentation(info="<html>
<h4>Support for Linux Socket CAN interface</h4>
<p>Modelica external function interface to use the CAN socket interface of the Linux kernel (<a href=\"https://www.kernel.org/doc/Documentation/networking/can.txt\">https://www.kernel.org/doc/Documentation/networking/can.txt</a>). </p>
<p><b>So far only tested with the virtual CAN interface &quot;vcan&quot;</b>. However, in principle it should work similarly with an underlying &quot;real&quot; CAN-device which is supported by the Socket CAN interface.</p>
<h4>Setup of a virtual CAN interface</h4>
<p>Even if a Linux computer doesn&apos;t have a CAN device, it is possible to setup a virtual CAN device that can be used similarly to a physical device. This section discusses the necessary steps to bring up a virtual CAN device (tested with Ubuntu 12.04) which can be used with the <a href=\"Modelica://Modelica_DeviceDrivers.Blocks.Examples.TestSerialPackager_SocketCAN\">SocketCAN example model</a>. Note that this usually requires root rights. Also executing the Modelica example model might require root rights.</p>
<ul>
<li>Load the vcan kernel model:<br/><code>sudo modprobe vcan</code></li>
<li>Create a virtual CAN device with default name (default name will be &quot;vcan0&quot;):<br/><code>sudo ip link add type vcan</code></li>
<li>Bring the device up:<br/><code>sudo ifconfig vcan0 up</code></li>
</ul>
<h4>Setup of a physical CAN interface</h4>
<p>Please have a look in the respective documentation to Socket CAN. A physical CAN interface will require more configuration settings than the virtual interface (e.g., bitrate setting).</p>
</html>"));
  end SocketCAN;

  package Internal
    extends Modelica.Icons.InternalPackage;
    package DummyFunctions
      extends Modelica.Icons.InternalPackage;
      function readUDP
        input Modelica_DeviceDrivers.Communication.UDPSocket socket;
        input Modelica_DeviceDrivers.Packaging.SerialPackager pkg;
        input Real dummy;
        output Real dummy2;
        output Integer nRecvBytes;
        output Integer nRecvbufOverwrites;
      algorithm
        (nRecvBytes, nRecvbufOverwrites) :=
          Modelica_DeviceDrivers.Communication.UDPSocket_.read(socket, pkg);
        dummy2 := dummy;
      end readUDP;

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

      function readSerial
        input Modelica_DeviceDrivers.Communication.SerialPort sPort
          "Serial Port object";
        input Modelica_DeviceDrivers.Packaging.SerialPackager pkg;
        input Real dummy;
        output Real dummy2;
      algorithm
        Modelica_DeviceDrivers.Communication.SerialPort_.read(sPort, pkg);
        dummy2 := dummy;
      end readSerial;

      function sendToSerial
        input Modelica_DeviceDrivers.Communication.SerialPort sPort
          "Serial Port object";
        input Modelica_DeviceDrivers.Packaging.SerialPackager pkg;
        input Integer dataSize "Size of data";
        input Real dummy;
        output Real dummy2;
      algorithm
        Modelica_DeviceDrivers.Communication.SerialPort_.sendTo(sPort, pkg, dataSize);
        dummy2 := dummy;
      end sendToSerial;

      function readTCPIPServer
        input Modelica_DeviceDrivers.Communication.TCPIPSocketClient socket;
        input Modelica_DeviceDrivers.Packaging.SerialPackager pkg;
        input Integer dataSize "Size of data";
        input Real dummy;
        output Real dummy2;
      algorithm
        Modelica_DeviceDrivers.Communication.TCPIPSocketClient_.read(socket, pkg, dataSize);
        dummy2 := dummy;
      end readTCPIPServer;

      function sendToTCPIPServer
        input Modelica_DeviceDrivers.Communication.TCPIPSocketClient socket;
        input Modelica_DeviceDrivers.Packaging.SerialPackager pkg;
        input Integer dataSize "Size of data";
        input Real dummy;
        output Real dummy2;
      algorithm
        Modelica_DeviceDrivers.Communication.TCPIPSocketClient_.sendTo(socket, pkg, dataSize);
        dummy2 := dummy;
      end sendToTCPIPServer;

      function readLCM
        input Modelica_DeviceDrivers.Communication.LCM lcm;
        input Modelica_DeviceDrivers.Packaging.SerialPackager pkg;
        input Real dummy;
        output Real dummy2;
      algorithm
        Modelica_DeviceDrivers.Communication.LCM_.read(lcm, pkg);
        dummy2 := dummy;
      end readLCM;

      function sendToLCM
        input Modelica_DeviceDrivers.Communication.LCM lcm;
        input String channel "Channel name";
        input Modelica_DeviceDrivers.Packaging.SerialPackager pkg;
        input Integer dataSize "Size of data";
        input Real dummy;
        output Real dummy2;
      algorithm
        Modelica_DeviceDrivers.Communication.LCM_.sendTo(lcm, channel, pkg, dataSize);
        dummy2 := dummy;
      end sendToLCM;

      function readMQTT
        input Modelica_DeviceDrivers.Communication.MQTT mqtt;
        input Modelica_DeviceDrivers.Packaging.SerialPackager pkg;
        input Real dummy;
        output Real dummy2;
      algorithm
        Modelica_DeviceDrivers.Communication.MQTT_.read(mqtt, pkg);
        dummy2 := dummy;
      end readMQTT;

      function sendToMQTT
        input Modelica_DeviceDrivers.Communication.MQTT mqtt;
        input String channel "Channel name";
        input Modelica_DeviceDrivers.Packaging.SerialPackager pkg;
        input Boolean retained "Retained flag";
        input Integer deliveryTimeout "Delivery timeout";
        input Integer dataSize "Size of data";
        input Real dummy;
        output Real dummy2;
      algorithm
        Modelica_DeviceDrivers.Communication.MQTT_.sendTo(mqtt, channel, pkg, retained, deliveryTimeout, dataSize);
        dummy2 := dummy;
      end sendToMQTT;
    end DummyFunctions;

    block PartialSampleTrigger
      "Common code for triggering calls to external I/O devices"
      import SI = Modelica.SIunits;
      parameter Boolean enableExternalTrigger = false
        "true, enable external trigger input signal, otherwise use sample time settings below"
        annotation (Dialog(group="Activation"), choices(checkBox=true));
      parameter SI.Period sampleTime = 0.1 "Sample period of component"
        annotation(Dialog(enable = not enableExternalTrigger, group="Activation"));
      parameter SI.Time startTime = 0 "First sample time instant"
        annotation(Dialog(enable = not enableExternalTrigger, group="Activation"));
      Modelica.Blocks.Interfaces.BooleanInput trigger if enableExternalTrigger
        annotation (Placement(transformation(
            extent={{-20,-20},{20,20}},
            rotation=90,
            origin={0,-120})));
    protected
      Modelica.Blocks.Interfaces.BooleanInput internalTrigger;
      Modelica.Blocks.Interfaces.BooleanInput conditionalInternalTrigger if not enableExternalTrigger;
      Modelica.Blocks.Interfaces.BooleanInput actTrigger annotation (HideResult=true);
    equation
      /* Conditional connect equations to either use external trigger or internal trigger */
      internalTrigger = sample(startTime,sampleTime);
      connect(internalTrigger, conditionalInternalTrigger);
      connect(conditionalInternalTrigger, actTrigger);
      connect(trigger, actTrigger);
      /* "actTrigger" can now be used by extending classes to trigger calls to I/O devices */
    end PartialSampleTrigger;
  end Internal;
end Communication;
