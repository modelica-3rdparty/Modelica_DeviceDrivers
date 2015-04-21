within Modelica_DeviceDrivers.Blocks;
package Communication
    extends Modelica.Icons.Package;
  model SharedMemoryRead
    "A block for reading data out of shared memory buffers"
    extends Modelica_DeviceDrivers.Utilities.Icons.BaseIcon;
    extends Modelica_DeviceDrivers.Utilities.Icons.SharedMemoryIcon;
    import Modelica_DeviceDrivers.Packaging.SerialPackager;
    import Modelica_DeviceDrivers.Packaging.alignAtByteBoundary;
    import Modelica_DeviceDrivers.Communication.SharedMemory;
    import Modelica_DeviceDrivers.Communication.SharedMemory_;
    parameter Modelica.SIunits.Period sampleTime=0.01 "Sample time for input update";
    parameter Boolean autoBufferSize = false
      "true, buffer size is deduced automatically, otherwise set it manually"
      annotation(Dialog(group="Shared memory partition"), choices(__Dymola_checkBox=true));
    parameter Integer userBufferSize=16*1024
      "Buffer size of shared memory partition in bytes (if not deduced automatically)"
                                                                                       annotation(Dialog(enable=not autoBufferSize, group="Shared memory partition"));
    parameter String memoryID="sharedMemory" "ID of the shared memory buffer" annotation(Dialog(group="Shared memory partition"));
    Modelica_DeviceDrivers.Blocks.Interfaces.PackageOut pkgOut(pkg = SerialPackager(bufferSize))
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
    pkgOut.trigger = sample(0,sampleTime);
    when pkgOut.trigger then
      pkgOut.dummy = Modelica_DeviceDrivers.Blocks.Packaging.SerialPackager.Internal.DummyFunctions.setPackage(
        pkgOut.pkg,
        SharedMemory_.read(sm),
        bufferSize,
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

  model SharedMemoryWrite "A block for writing data in a shared memory"
    import Modelica_DeviceDrivers;
    extends Modelica_DeviceDrivers.Utilities.Icons.BaseIcon;
    extends Modelica_DeviceDrivers.Utilities.Icons.SharedMemoryIcon;
    import Modelica_DeviceDrivers.Packaging.SerialPackager;
    import Modelica_DeviceDrivers.Communication.SharedMemory;
    parameter Modelica.SIunits.Period sampleTime=0.01 "Sample time for update";
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
    SharedMemory sm = SharedMemory(memoryID, bufferSize);
    Integer bufferSize;
    Real dummy;
  equation
    when initial() then
      pkgIn.userPkgBitSize = if autoBufferSize then -1 else userBufferSize*8;
      pkgIn.autoPkgBitSize = 0;
      bufferSize = if autoBufferSize then Modelica_DeviceDrivers.Packaging.SerialPackager_.getBufferSize(pkgIn.pkg) else userBufferSize;
    end when;
    pkgIn.backwardTrigger = sample(0, sampleTime);
    when pkgIn.trigger then
      dummy =
        Modelica_DeviceDrivers.Blocks.Communication.Internal.DummyFunctions.writeSharedMemory(
        sm,
        Modelica_DeviceDrivers.Packaging.SerialPackager_.getPackage(
                                  pkgIn.pkg),
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

  model UDPReceive "A block for receiving UDP datagrams"
    extends Modelica_DeviceDrivers.Utilities.Icons.BaseIcon;
    extends Modelica_DeviceDrivers.Utilities.Icons.UDPconnection;
    import Modelica_DeviceDrivers.Packaging.SerialPackager;
    import Modelica_DeviceDrivers.Packaging.alignAtByteBoundary;
    import Modelica_DeviceDrivers.Communication.UDPSocket;
    parameter Modelica.SIunits.Period sampleTime=0.01 "Sample time for input update";
    parameter Boolean autoBufferSize = true
      "true, buffer size is deduced automatically, otherwise set it manually"
      annotation(Dialog(group="Incoming data"), choices(__Dymola_checkBox=true));
    parameter Integer userBufferSize=16*1024
      "Buffer size of message data in bytes (if not deduced automatically)" annotation(Dialog(enable=not autoBufferSize, group="Incoming data"));
    parameter Integer port_recv=10001
      "Listening port number of the server. Must be unique on the system"
      annotation (Dialog(group="Incoming data"));
    Modelica_DeviceDrivers.Blocks.Interfaces.PackageOut pkgOut(pkg = SerialPackager(bufferSize))
                                       annotation (Placement(transformation(
          extent={{-20,-20},{20,20}},
          rotation=90,
          origin={108,0})));

  protected
    Integer bufferSize;
    UDPSocket socket = UDPSocket(port_recv, bufferSize);
  equation
    when initial() then
      bufferSize = if autoBufferSize then alignAtByteBoundary(pkgOut.autoPkgBitSize) else userBufferSize;
    end when;
    pkgOut.trigger = sample(0,sampleTime);

    when pkgOut.trigger then
      pkgOut.dummy = Modelica_DeviceDrivers.Blocks.Packaging.SerialPackager.Internal.DummyFunctions.setPackage(
        pkgOut.pkg,
        Modelica_DeviceDrivers.Communication.UDPSocket_.read(socket),
        bufferSize,
        time);
    end when;

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
    import Modelica_DeviceDrivers.Packaging.SerialPackager;
    import Modelica_DeviceDrivers.Communication.UDPSocket;

    parameter Modelica.SIunits.Period sampleTime=0.01 "Sample time for update";
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
    UDPSocket socket = UDPSocket(0);
    Integer bufferSize;
    Real dummy;
  equation
    when initial() then
      pkgIn.userPkgBitSize = if autoBufferSize then -1 else userBufferSize*8;
      pkgIn.autoPkgBitSize = 0;
      bufferSize = if autoBufferSize then Modelica_DeviceDrivers.Packaging.SerialPackager_.getBufferSize(pkgIn.pkg) else userBufferSize;
    end when;
    pkgIn.backwardTrigger = sample(0, sampleTime);
    when pkgIn.trigger then
      dummy =
         Modelica_DeviceDrivers.Blocks.Communication.Internal.DummyFunctions.sendToUDP(
        socket,
        IPAddress,
        port_send,
        Modelica_DeviceDrivers.Packaging.SerialPackager_.getPackage(pkgIn.pkg),
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

  model SerialPortReceive
    "A block for receiving serial datagrams using the serial interface"
    extends Modelica_DeviceDrivers.Utilities.Icons.SerialPortIcon;
    import Modelica_DeviceDrivers.Packaging.SerialPackager;
    import Modelica_DeviceDrivers.Packaging.alignAtByteBoundary;
    import Modelica_DeviceDrivers.Communication.SerialPort;
    import Modelica_DeviceDrivers.Utilities.Types.SerialBaudRate;
    parameter Modelica.SIunits.Period sampleTime=0.01 "Sample time for input update";
    parameter Boolean autoBufferSize = true
      "true, buffer size is deduced automatically, otherwise set it manually"
      annotation(Dialog(group="Incoming data"), choices(__Dymola_checkBox=true));
    parameter Integer userBufferSize=16*64
      "Buffer size of message data in bytes (if not deduced automatically)" annotation(Dialog(enable=not autoBufferSize, group="Incoming data"));
    parameter String Serial_Port="/dev/ttyPS1" "Serial port to send data"
     annotation (Dialog(group="Incoming data"));
    parameter SerialBaudRate baud= SerialBaudRate.B9600 "Serial port baud rate"
    annotation (Dialog(group="Incoming data"));
    parameter Integer parity = 0
      "set parity (0 - no parity, 1 - even, 2 - odd)"
        annotation (Dialog(group="Outgoing data"));
    Modelica_DeviceDrivers.Blocks.Interfaces.PackageOut pkgOut(pkg = SerialPackager(bufferSize))
                                       annotation (Placement(transformation(
          extent={{-20,-20},{20,20}},
          rotation=90,
          origin={108,0})));

  protected
    Integer bufferSize;
    SerialPort sPort = SerialPort(Serial_Port, bufferSize, parity, receiver, baud);
    parameter Integer receiver = 1 "Set to be a receiver port";

  equation
    when initial() then
      bufferSize = if autoBufferSize then alignAtByteBoundary(pkgOut.autoPkgBitSize) else userBufferSize;
    end when;
    pkgOut.trigger = sample(0,sampleTime);

    when pkgOut.trigger then
      pkgOut.dummy =
        Modelica_DeviceDrivers.Blocks.Packaging.SerialPackager.Internal.DummyFunctions.setPackage(
        pkgOut.pkg,
        Modelica_DeviceDrivers.Communication.SerialPort_.read(sPort),
        bufferSize,
        time);
    end when;

    annotation (preferredView="info",
            Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,
              -100},{100,100}}), graphics={Text(extent={{-150,136},{150,96}},
              textString="%name"),         Text(extent={{-150,82},{150,42}},
            textString="%Serial_Port"),            Text(extent={{-152,-48},{148,-88}},
            textString="%baud")}), Documentation(info="<html>
<h4><font color=\"#008000\">Support for receiving datagrams over a serial port</font></h4>
<h4><font color=\"#008000\">Example</font></h4>
<p>
See <a href=\"modelica://Modelica_DeviceDrivers.Blocks.Examples.TestSerialPackager_SerialPort\"><code>TestSerialPackager_SerialPort</code></a>.
</p>
</html>"));
  end SerialPortReceive;

  model SerialPortSend
    "A block for sending serial datagrams using the serial interface"
    extends Modelica_DeviceDrivers.Utilities.Icons.SerialPortIcon;
    import Modelica_DeviceDrivers.Packaging.SerialPackager;
    import Modelica_DeviceDrivers.Communication.SerialPort;
    import Modelica_DeviceDrivers.Utilities.Types.SerialBaudRate;

    parameter Modelica.SIunits.Period sampleTime=0.01 "Sample time for update";
    parameter Boolean autoBufferSize = true
      "true, buffer size is deduced automatically, otherwise set it manually."
      annotation(Dialog(group="Outgoing data"), choices(__Dymola_checkBox=true));
    parameter Integer userBufferSize=16*64
      "Buffer size of message data in bytes (if not deduced automatically)." annotation(Dialog(enable=not autoBufferSize, group="Outgoing data"));
                                             //16*1024
    parameter String Serial_Port="/dev/ttyPS0" "SerialPort to sendData"
        annotation (Dialog(group="Outgoing data"));
    parameter SerialBaudRate baud = SerialBaudRate.B9600
      "Serial port baud rate"
        annotation (Dialog(group="Outgoing data"));
    parameter Integer parity = 0
      "set parity (0 - no parity, 1 - even, 2 - odd)"
        annotation (Dialog(group="Outgoing data"));

    Modelica_DeviceDrivers.Blocks.Interfaces.PackageIn pkgIn annotation (
        Placement(transformation(
          extent={{-20,-20},{20,20}},
          rotation=270,
          origin={-108,0})));
  protected
    SerialPort sPort = SerialPort(Serial_Port, bufferSize, parity, receiver, baud); // Creating port object from device
    Integer bufferSize;
    parameter Integer receiver = 0 "Set to be a sender port";
    Real dummy;
  equation
    when initial() then
      pkgIn.userPkgBitSize = if autoBufferSize then -1 else userBufferSize*8;
      pkgIn.autoPkgBitSize = 0;
      bufferSize = if autoBufferSize then Modelica_DeviceDrivers.Packaging.SerialPackager_.getBufferSize(pkgIn.pkg) else userBufferSize;
    end when;

    pkgIn.backwardTrigger = sample(0, sampleTime);

    when pkgIn.trigger then
       dummy =
         Modelica_DeviceDrivers.Blocks.Communication.Internal.DummyFunctions.sendToSerial(
           sPort,
           Modelica_DeviceDrivers.Packaging.SerialPackager_.getPackage(pkgIn.pkg),
           bufferSize,
           pkgIn.dummy);
    end when;
    annotation (preferredView="info",
            Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,
              -100},{100,100}}), graphics={Text(extent={{-150,136},{150,96}},
              textString="%name"),         Text(extent={{-150,82},{150,42}},
            textString="%Serial_Port"),            Text(extent={{-154,-44},{146,-84}},
            textString="%baud")}), Documentation(info="<html>
<h4><font color=\"#008000\">Support for sending datagrams over a serial port</font></h4>
<h4><font color=\"#008000\">Example</font></h4>
<p>
See <a href=\"modelica://Modelica_DeviceDrivers.Blocks.Examples.TestSerialPackager_SerialPort\"><code>TestSerialPackager_SerialPort</code></a>.
</p>
</html>"));
  end SerialPortSend;

  model TCPIP_Client_IO "A client block for TCP/IP socket communcication"
    import Modelica_DeviceDrivers;
    extends Modelica_DeviceDrivers.Utilities.Icons.BaseIcon;
    import Modelica_DeviceDrivers.Packaging.SerialPackager;
    import Modelica_DeviceDrivers.Communication.TCPIPSocketClient;

    parameter Modelica.SIunits.Period sampleTime=0.01 "Sample time for update";
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

    pkgIn.backwardTrigger = sample(0, sampleTime);
    pkgOut.trigger = pkgIn.backwardTrigger;
    when pkgIn.backwardTrigger then
      if isConnected then
        pkgOut.dummy = Modelica_DeviceDrivers.Blocks.Packaging.SerialPackager.Internal.DummyFunctions.setPackage(
          pkgOut.pkg,
          Modelica_DeviceDrivers.Communication.TCPIPSocketClient_.read(socket, inputBufferSize),
          inputBufferSize,
          Modelica_DeviceDrivers.Blocks.Communication.Internal.DummyFunctions.sendToTCPIPServer(
            socket,
            Modelica_DeviceDrivers.Packaging.SerialPackager_.getPackage(pkgIn.pkg),
            outputBufferSize,
            pkgIn.dummy));
      else
        pkgOut.dummy = pre(pkgOut.dummy);
      end if;
    end when;
    annotation (preferredView="info",
            Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,
              -100},{100,100}}), graphics={Text(extent={{-150,136},{150,96}},
              textString="%name")}), Documentation(info="<html>
<p>Supports sending/receiving of packets to/from a server over TCP/IP.</p>
</html>"));
  end TCPIP_Client_IO;

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
<h4><font color=\"#008000\">Support for Softing CAN bus</font></h4>
<p><b>Please, read the package information for <a href=\"modelica://Modelica_DeviceDrivers.Blocks.Communication.SoftingCAN\"><code>SoftingCAN</code></a> first!</b></p>
<h4><font color=\"#008000\">Example</font></h4>
<p>
See <a href=\"modelica://Modelica_DeviceDrivers.Blocks.Examples.TestSerialPackager_SoftingCAN\"><code>TestSerialPackager_SoftingCAN</code></a>.
</p>
</html>"));
    end SoftingCANConfig;

    block SoftingReadMessage "Set up a message for receiving data"
      import Modelica_DeviceDrivers;

    extends Modelica_DeviceDrivers.Blocks.Interfaces.PartialSoftingCANMessage;
      import Modelica_DeviceDrivers.Communication.SoftingCAN;
      import Modelica_DeviceDrivers.Utilities.Types;
      import Modelica_DeviceDrivers.Packaging.SerialPackager;
      import SI = Modelica.SIunits;
    parameter Integer ident(min=0) "Identifier of CAN message (CAN Id)";
    parameter SI.Period sampleTime = 0.1 "Period at which messages are written";
    parameter SI.Time startTime = 0 "First sample time instant";
      Modelica_DeviceDrivers.Blocks.Interfaces.PackageOut pkgOut
        annotation (Placement(transformation(extent={{-20,-128},{20,-88}})));
    protected
      Integer objectNumber;
      Modelica_DeviceDrivers.Packaging.SerialPackager pkg = SerialPackager(8);
    initial equation
      objectNumber = Modelica_DeviceDrivers.Communication.SoftingCAN_.defineObject(
        softingCANBus.softingCAN,
        ident,
        Types.TransmissionType.standardReceive);
      softingCANBus.dummy = 1;
    equation
      pkgOut.trigger = sample(startTime, sampleTime);
      when pkgOut.trigger then
        objectNumber = pre(objectNumber);
        pkgOut.dummy = Modelica_DeviceDrivers.Blocks.Packaging.SerialPackager.Internal.DummyFunctions.setPackage(
        pkgOut.pkg,
        Modelica_DeviceDrivers.Communication.SoftingCAN_.readRcvData(
          softingCANBus.softingCAN,
          objectNumber,
          pkgOut.pkg),
        8,
        time);

        softingCANBus.dummy = pre(softingCANBus.dummy);
      end when;

      pkgOut.pkg = pkg;
      annotation (defaultComponentName="rxMessage",
      Icon(graphics={Text(
              extent={{-98,54},{98,26}},
              textString="Rx id: %ident"),
            Text(
              extent={{-160,24},{160,-6}},
              textString="(%startTime, %sampleTime) s")}),
        Documentation(info="<html>
<h4><font color=\"#008000\">Support for Softing CAN bus</font></h4>
<p><b>Please, read the package information for <a href=\"modelica://Modelica_DeviceDrivers.Blocks.Communication.SoftingCAN\"><code>SoftingCAN</code></a> first!</b></p>
<h4><font color=\"#008000\">Example</font></h4>
<p>
See <a href=\"modelica://Modelica_DeviceDrivers.Blocks.Examples.TestSerialPackager_SoftingCAN\"><code>TestSerialPackager_SoftingCAN</code></a>.
</p>
</html>"));
    end SoftingReadMessage;

    block SoftingWriteMessage "Set up a message for transmitting data"
      import Modelica_DeviceDrivers;
      extends Modelica_DeviceDrivers.Blocks.Interfaces.PartialSoftingCANMessage;
      import Modelica_DeviceDrivers.Communication.SoftingCAN;
      import Modelica_DeviceDrivers.Packaging.SerialPackager;
      import Modelica_DeviceDrivers.Utilities.Types;
      import SI = Modelica.SIunits;
    parameter Integer ident(min=0) "Identifier of CAN message (CAN Id)";
    parameter Integer dlc(min=0,max=8) = 8
        "Data length code (payload of data in bytes, max=8)";
    parameter SI.Period sampleTime = 0.1 "Sample period of component";
    parameter SI.Time startTime = 0 "First sample time instant";
      Modelica_DeviceDrivers.Blocks.Interfaces.PackageIn pkgIn
        annotation (Placement(transformation(extent={{-20,-128},{20,-88}})));
    protected
      Integer objectNumber;
      Real dummy;
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

      pkgIn.backwardTrigger = sample(startTime, sampleTime);
      when pkgIn.trigger then
        objectNumber = pre(objectNumber);
        dummy = Modelica_DeviceDrivers.Blocks.Communication.SoftingCAN.Internal.writeObjectDummy(
          softingCANBus.softingCAN,
          objectNumber,
          dlc,
          Modelica_DeviceDrivers.Packaging.SerialPackager_.getPackage(pkgIn.pkg),
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
<h4><font color=\"#008000\">Support for Softing CAN bus</font></h4>
<p><b>Please, read the package information for <a href=\"modelica://Modelica_DeviceDrivers.Blocks.Communication.SoftingCAN\"><code>SoftingCAN</code></a> first!</b></p>
<h4><font color=\"#008000\">Example</font></h4>
<p>
See <a href=\"modelica://Modelica_DeviceDrivers.Blocks.Examples.TestSerialPackager_SoftingCAN\"><code>TestSerialPackager_SoftingCAN</code></a>.
</p>
</html>"));
    end SoftingWriteMessage;

    package Internal
      extends Modelica_DeviceDrivers.Utilities.Icons.InternalPackage;
    encapsulated function startChipDummy
        import Modelica_DeviceDrivers.Communication.SoftingCAN;
        import Modelica_DeviceDrivers;
      input Modelica_DeviceDrivers.Communication.SoftingCAN
                       softingCAN "Handle for device";
      input Real dummy;
    algorithm
      Modelica_DeviceDrivers.Communication.SoftingCAN_.startChip(softingCAN);
    end startChipDummy;

    encapsulated function writeObjectDummy
        "Write object (CAN message) to transmit buffer"
        import Modelica_DeviceDrivers.Communication.SoftingCAN;
        import Modelica_DeviceDrivers;

      input Modelica_DeviceDrivers.Communication.SoftingCAN
                       softingCAN "Handle for device";
      input Integer objectNumber
          "Object number of message (from defineObject(..))";
      input Integer dataLength "Length of message in bytes";
      input String data "The payload data";
      input Real dummy;
      output Real dummy2;
    algorithm
      Modelica_DeviceDrivers.Communication.SoftingCAN_.writeObject(
                             softingCAN, objectNumber, dataLength, data);
      dummy2 := dummy;
    end writeObjectDummy;
    end Internal;
    annotation (preferredView="info",
    Documentation(info="<html>
<h4><font color=\"#008000\">Prototypical support for Softing CAN interfaces</font></h4>
Please note, that the support for CAN is considered <b>prototypical</b>. Even more than for the other elements in this library there might be severe bugs in it and you use it on <b>your own risk</b>. Additionally, the API of the blocks is more likely to change in the future. So please, refrain from using it for building your next nuclear power plant or fly-by-wire system ...
<font color=\"#008000\">System Requirements</font>
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
<h4><font color=\"#008000\">Support for Linux Socket CAN bus</font></h4>
<p><b>Please, read the package information for <a href=\"modelica://Modelica_DeviceDrivers.Blocks.Communication.SocketCAN\"><code>SocketCAN</code></a> first!</b></p>
<h4><font color=\"#008000\">Example</font></h4>
<p>
See <a href=\"modelica://Modelica_DeviceDrivers.Blocks.Examples.TestSerialPackager_SocketCAN\"><code>TestSerialPackager_SocketCAN</code></a>.
</p>
</html>"));
    end SocketCANConfig;

    block ReadMessage "Set up a message for receiving data"
      extends Modelica_DeviceDrivers.Utilities.Icons.BaseIcon;
      extends Modelica_DeviceDrivers.Utilities.Icons.SocketCANBlockIcon;
      import Modelica_DeviceDrivers;
      import Modelica_DeviceDrivers.Communication.SocketCAN;
      import Modelica_DeviceDrivers.Packaging.SerialPackager;
      import SI = Modelica.SIunits;
    parameter SocketCANConfig config
        "Socket CAN configuration (socket) to use for this block"                              annotation (__Dymola_componentsMatching=true);
    parameter Integer can_id(min=0) "Identifier of CAN message (CAN Id)";
    parameter Integer can_dlc(min=0,max=8) = 8
        "Data length code (payload of data in bytes, max=8)";
    parameter SI.Period sampleTime = 0.1 "Period at which messages are written";
    parameter SI.Time startTime = 0 "First sample time instant";
      Modelica_DeviceDrivers.Blocks.Interfaces.PackageOut pkgOut
        annotation (Placement(transformation(extent={{-20,-20},{20,20}},
            rotation=90,
            origin={108,0})));
    protected
      Modelica_DeviceDrivers.Packaging.SerialPackager pkg = SerialPackager(can_dlc);
    initial equation
      Modelica_DeviceDrivers.Communication.SocketCAN_.defineObject(
        config.dh,
        can_id,
        can_dlc);
    equation
      pkgOut.trigger = sample(startTime, sampleTime);
      when pkgOut.trigger then
        pkgOut.dummy = Modelica_DeviceDrivers.Blocks.Packaging.SerialPackager.Internal.DummyFunctions.setPackage(
        pkgOut.pkg,
        Modelica_DeviceDrivers.Communication.SocketCAN_.readObject(
          config.dh,
          can_id,
          can_dlc,
          Modelica_DeviceDrivers.Packaging.SerialPackager_.getPackage(pkgOut.pkg)),
        can_dlc,
        time);
      end when;

      pkgOut.pkg = pkg;
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
<h4><font color=\"#008000\">Support for Linux Socket CAN interface</font></h4>
<p><b>Please, read the package information for <a href=\"modelica://Modelica_DeviceDrivers.Blocks.Communication.SocketCAN\"><code>SocketCAN</code></a> first!</b></p>
<h4><font color=\"#008000\">Example</font></h4>
<p>
See <a href=\"modelica://Modelica_DeviceDrivers.Blocks.Examples.TestSerialPackager_SocketCAN\"><code>TestSerialPackager_SocketCAN</code></a>.
</p>
</html>"));
    end ReadMessage;

    block WriteMessage "Set up a message for transmitting data"
      import Modelica_DeviceDrivers;
      extends Modelica_DeviceDrivers.Utilities.Icons.BaseIcon;
      extends Modelica_DeviceDrivers.Utilities.Icons.SocketCANBlockIcon;
      import Modelica_DeviceDrivers.Communication.SocketCAN;
      import Modelica_DeviceDrivers.Packaging.SerialPackager;
      import SI = Modelica.SIunits;
    parameter SocketCANConfig config
        "Socket CAN configuration (socket) to use for this block"                              annotation (__Dymola_componentsMatching=true);
    parameter Integer can_id(min=0) "Identifier of CAN message (CAN Id)";
    parameter Integer can_dlc(min=0,max=8) = 8
        "Data length code (payload of data in bytes, max=8)";
    parameter SI.Period sampleTime = 0.1 "Sample period of component";
    parameter SI.Time startTime = 0 "First sample time instant";
      Modelica_DeviceDrivers.Blocks.Interfaces.PackageIn pkgIn
        annotation (Placement(transformation(extent={{-20,-20},{20,20}},
            rotation=-90,
            origin={-108,0})));
    protected
      Real dummy;
    equation
      when initial() then
        pkgIn.userPkgBitSize = can_dlc*8;
        pkgIn.autoPkgBitSize = 0;
        Modelica_DeviceDrivers.Communication.SocketCAN_.defineObject(
                               config.dh, can_id, can_dlc);
      end when;

      pkgIn.backwardTrigger = sample(startTime, sampleTime);
      when pkgIn.trigger then
        dummy = Modelica_DeviceDrivers.Blocks.Communication.SocketCAN.Internal.writeDummy(
          config.dh,
          can_id,
          can_dlc,
          Modelica_DeviceDrivers.Packaging.SerialPackager_.getPackage(pkgIn.pkg),
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
<h4><font color=\"#008000\">Support for Linux Socket CAN interface</font></h4>
<p><b>Please, read the package information for <a href=\"modelica://Modelica_DeviceDrivers.Blocks.Communication.SocketCAN\"><code>SocketCAN</code></a> first!</b></p>
<h4><font color=\"#008000\">Example</font></h4>
<p>
See <a href=\"modelica://Modelica_DeviceDrivers.Blocks.Examples.TestSerialPackager_SocketCAN\"><code>TestSerialPackager_SocketCAN</code></a>.
</p>
</html>"));
    end WriteMessage;

    package Internal
      extends Modelica_DeviceDrivers.Utilities.Icons.InternalPackage;

    encapsulated function writeDummy "Write CAN frame/message to socket"
        import Modelica_DeviceDrivers.Communication.SocketCAN;
        import Modelica_DeviceDrivers;

      input SocketCAN socketCAN;
      input Integer can_id "CAN frame identifier";
      input Integer can_dlc(min=0,max=8)
          " length of data in bytes (min=0, max=8)";
      input String data "The payload data";
      input Real dummy;
      output Real dummy2;
    algorithm
      Modelica_DeviceDrivers.Communication.SocketCAN_.write(
                      socketCAN, can_id, can_dlc, data);
      dummy2 := dummy;
    end writeDummy;
    end Internal;
    annotation (preferredView="info",Documentation(info="<html>
<h4><font color=\"#008000\">Support for Linux Socket CAN interface</font></h4>
<p>Modelica external function interface to use the CAN socket interface of the Linux kernel (<a href=\"http://svn.berlios.de/wsvn/socketcan/trunk/kernel/2.6/Documentation/networking/can.txt\">http://svn.berlios.de/wsvn/socketcan/trunk/kernel/2.6/Documentation/networking/can.txt</a>). </p>
<p><b>So far only testet with the virtual CAN interface &quot;vcan&quot;</b>. However, in principle it should work similarly with an underlying &quot;real&quot; CAN-device which is supported by the Socket CAN interface.</p>
<h4><font color=\"#008000\">Setup of a virtual CAN interface</font></h4>
<p>Even if a Linux computer doesn&apos;t have a CAN device, it is possible to setup a virtual CAN device that can be used similarly to a physical device. This section discusses the necessary steps to bring up a virtual CAN device (tested with Ubuntu 12.04) which can be used with the <a href=\"Modelica://Modelica_DeviceDrivers.Blocks.Examples.TestSerialPackager_SocketCAN\">SocketCAN example model</a>. Note that this usually requires root rights. Also executing the Modelica example model might require root rights.</p>
<ul>
<li>Load the vcan kernel model:<br/><code>sudo modprobe vcan</code></li>
<li>Create a virtual CAN device with default name (default name will be &quot;vcan0&quot;):<br/><code>sudo ip link add type vcan</code></li>
<li>Bring the device up:<br/><code>sudo ifconfig vcan0 up</code></li>
</ul>
<h4><font color=\"#008000\">Setup of a physical CAN interface</font></h4>
<p>Please have a look in the respective documentation to Socket CAN. A physical CAN interface will require more configuration settings than the virtual interface (e.g., bitrate setting).</p>
</html>"));
  end SocketCAN;

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
        Modelica_DeviceDrivers.Communication.UDPSocket_.sendTo(
                            socket, ipAddress, port,data, dataSize);
        dummy2 :=dummy;
      end sendToUDP;

      function writeSharedMemory
        input Modelica_DeviceDrivers.Communication.SharedMemory sm;
        input String data;
        input Integer len;
        input Real dummy;
        output Real dummy2;
      algorithm
        Modelica_DeviceDrivers.Communication.SharedMemory_.write(sm,data,len);
        dummy2 :=dummy;
      end writeSharedMemory;

      function sendToSerial
        import Modelica_DeviceDrivers.Communication.SerialPort;
        input SerialPort sPort "Serial Port object";
        input String data "Data to be sent";
        input Integer dataSize "Size of data";
        input Real dummy;
        output Real dummy2;
      algorithm
        Modelica_DeviceDrivers.Communication.SerialPort_.sendTo(
          sPort,
          data,
          dataSize);
        dummy2 :=dummy;
      end sendToSerial;

      function sendToTCPIPServer
        import Modelica_DeviceDrivers.Communication.TCPIPSocketClient;
        input TCPIPSocketClient socket;
        input String data "Data to be sent";
        input Integer dataSize "Size of data";
        input Real dummy;
        output Real dummy2;
      algorithm
        Modelica_DeviceDrivers.Communication.TCPIPSocketClient_.sendTo(
                            socket, data, dataSize);
        dummy2 := dummy;
      end sendToTCPIPServer;
    end DummyFunctions;
  end Internal;
end Communication;
