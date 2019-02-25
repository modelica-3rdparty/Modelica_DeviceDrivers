within Modelica_DeviceDrivers.Communication;
package TCPIPServer_ "Accompanying functions for the TCP/IP server"
  extends Modelica_DeviceDrivers.Utilities.Icons.DriverIcon;
  function read
    extends Modelica.Icons.Function;
    input Modelica_DeviceDrivers.Communication.TCPIPServer tcpipserver;
    input Integer clientIndex "Index of the TCP/IP client";
    input Integer recvbuflen "Size of receive buffer";
    output String data;
    output Integer nRecvBytes "Number of received bytes. If 0 it means that no new data is available.";
    external "C" data = MDD_TCPIPServer_read(tcpipserver, clientIndex, recvbuflen, nRecvBytes)
    annotation(Include = "#include \"MDDTCPIPSocketServer.h\"");
  end read;

  function send
    extends Modelica.Icons.Function;
    input Modelica_DeviceDrivers.Communication.TCPIPServer tcpipserver;
    input Integer clientIndex "Index of the TCP/IP client";
    input Integer dataSize "Size of data to be sent in byte";
    input String data "Data that should be sent";
    output Integer dataSent;
    external "C" dataSent = MDD_TCPIPServer_send(tcpipserver, data, dataSize, clientIndex)
    annotation(Include = "#include \"MDDTCPIPSocketServer.h\"");
  end send;

  function readP
    extends Modelica.Icons.Function;
    input Modelica_DeviceDrivers.Communication.TCPIPServer tcpipserver;
    input Modelica_DeviceDrivers.Packaging.SerialPackager pkg;
    input Integer clientIndex "Index of the TCP/IP client";
    input Integer recvbuflen "Size of receive buffer";
    output Integer nRecvBytes "Number of received bytes. If 0 it means that no new data is available.";
    external "C" MDD_TCPIPServer_readP(tcpipserver, pkg, clientIndex, recvbuflen, nRecvBytes)
    annotation(Include = "#include \"MDDTCPIPSocketServer.h\"");
  end readP;

  function sendP
    extends Modelica.Icons.Function;
    input Modelica_DeviceDrivers.Communication.TCPIPServer tcpipserver;
    input Modelica_DeviceDrivers.Packaging.SerialPackager pkg;
    input Integer dataSize "Size of data to be sent in byte";
    input Integer clientIndex "Index of the TCP/IP client";
    output Integer dataSent;
    external "C" dataSent = MDD_TCPIPServer_sendP(tcpipserver, pkg, dataSize, clientIndex)
    annotation(Include = "#include \"MDDTCPIPSocketServer.h\"");
  end sendP;

  function acceptedClients
    extends Modelica.Icons.Function;
    input Modelica_DeviceDrivers.Communication.TCPIPServer tcpipserver;
    input Integer maxClients "Number of clients for which the tcpipserver object was configured";
    output Boolean acceptedClients[maxClients] "=true, a client was accepted at the respective index position";
    external "C" MDD_TCPIPServer_acceptedClients(tcpipserver, acceptedClients, maxClients)
    annotation(Include = "#include \"MDDTCPIPSocketServer.h\"");
  end acceptedClients;

  function hasAcceptedClient
    "Check if a client at the specified index has been accepted by the server."
    extends Modelica.Icons.Function;
    input Modelica_DeviceDrivers.Communication.TCPIPServer tcpipserver;
    input Integer clientIndex;
    output Boolean accepted;
    external "C" accepted = MDD_TCPIPServer_hasAcceptedClient(tcpipserver, clientIndex)
    annotation(Include = "#include \"MDDTCPIPSocketServer.h\"");
  end hasAcceptedClient;
end TCPIPServer_;
