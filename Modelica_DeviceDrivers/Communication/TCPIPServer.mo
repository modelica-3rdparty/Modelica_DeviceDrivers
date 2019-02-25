within Modelica_DeviceDrivers.Communication;
class TCPIPServer "A server for TCP/IP packet network communication."
extends ExternalObject;
  encapsulated function constructor
    "Creates a TCP/IP socket server instance."
    import Modelica;
    extends Modelica.Icons.Function;
    import Modelica_DeviceDrivers.Communication.TCPIPServer;

    input Integer port "The listening port of the server";
    input Integer maxClients = 1 "Maximum number of clients that can connect simultaneously";
    input Boolean useNonblockingMode = true "=true, use non-blocking TCP/IP socket, otherwise receiving and sending will block";
    output TCPIPServer tcpipserver;
  external "C" tcpipserver = MDD_TCPIPServer_Constructor(port, maxClients, useNonblockingMode)
  annotation(Include = "#include \"MDDTCPIPSocketServer.h\"");
  end constructor;

  encapsulated function destructor
    "Closes a TCP/IP socket server instance."
    import Modelica;
    extends Modelica.Icons.Function;
    import Modelica_DeviceDrivers.Communication.TCPIPServer;
    input TCPIPServer tcpipserver;
    external "C" MDD_TCPIPServer_Destructor(tcpipserver)
    annotation(Include = "#include \"MDDTCPIPSocketServer.h\"");
  end destructor;

end TCPIPServer;
