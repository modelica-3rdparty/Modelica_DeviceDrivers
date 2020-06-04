within Modelica_DeviceDrivers.Communication;
package TCPIPSocketClient_ "Accompanying functions for the TCP/IP socket client object"
  extends Modelica_DeviceDrivers.Utilities.Icons.DriverIcon;

  encapsulated function connect_
    "Connects to a TCP/IP socket server."
    import Modelica;
    extends Modelica.Icons.Function;
    import Modelica_DeviceDrivers.Communication.TCPIPSocketClient;
    input TCPIPSocketClient socketClient;
    input String ip "IP address";
    input Integer port "Port";
    output Boolean isConnected;
    external "C" isConnected = MDD_TCPIPClient_Connect(socketClient, ip, port)
    annotation(Include = "#include \"MDDTCPIPSocket.h\"",
           Library = {"pthread", "Ws2_32"},
           __iti_dll = "ITI_MDD.dll",
           __iti_dllNoExport = true);
  end connect_;

  encapsulated function read
    import Modelica;
    extends Modelica.Icons.Function;
    import Modelica_DeviceDrivers.Communication.TCPIPSocketClient;
    import Modelica_DeviceDrivers.Packaging.SerialPackager;
    input TCPIPSocketClient socketClient;
    input SerialPackager pkg "Data package to be read";
    input Integer dataSize "Size of data";
    external "C" MDD_TCPIPClient_ReadP(socketClient, pkg, dataSize)
    annotation(Include = "#include \"MDDTCPIPSocket.h\"",
           Library = {"pthread", "Ws2_32"},
           __iti_dll = "ITI_MDD.dll",
           __iti_dllNoExport = true);
  end read;

  encapsulated function sendTo
    import Modelica;
    extends Modelica.Icons.Function;
    import Modelica_DeviceDrivers.Communication.TCPIPSocketClient;
    import Modelica_DeviceDrivers.Packaging.SerialPackager;
    input TCPIPSocketClient socketClient;
    input SerialPackager pkg "Data package to be sent";
    input Integer dataSize "Size of data";
    output Integer sendError "Send error flag";
    external "C" sendError = MDD_TCPIPClient_SendP(socketClient, pkg, dataSize)
    annotation(Include = "#include \"MDDTCPIPSocket.h\"",
           Library = {"pthread", "Ws2_32"},
           __iti_dll = "ITI_MDD.dll",
           __iti_dllNoExport = true);
  end sendTo;
end TCPIPSocketClient_;
