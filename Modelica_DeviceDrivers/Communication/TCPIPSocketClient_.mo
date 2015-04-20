within Modelica_DeviceDrivers.Communication;
package TCPIPSocketClient_ "Accompanying functions for the TCP/IP socket client object"
  extends Modelica_DeviceDrivers.Utilities.Icons.DriverIcon;
  encapsulated function read
    import Modelica_DeviceDrivers.Communication.TCPIPSocketClient;
    input TCPIPSocketClient socketClient;
    input Integer dataSize "Size of data";
    output String data "Data to be received";
    external "C" data = MDD_TCPIPClient_Read(socketClient, dataSize)
    annotation(IncludeDirectory="modelica://Modelica_DeviceDrivers/Resources/Include",
           Include = "#include \"MDDTCPIPSocket.h\" ",
           Library = {"pthread", "Ws2_32"},
           __iti_dll = "ITI_MDD.dll");
  end read;

  encapsulated function sendTo
    import Modelica_DeviceDrivers.Communication.TCPIPSocketClient;
    input TCPIPSocketClient socketClient;
    input String data "Data to be sent";
    input Integer dataSize "Size of data";
    output Integer sendError "Send error flag";
    external "C" sendError = MDD_TCPIPClient_Send(socketClient, data, dataSize)
    annotation(IncludeDirectory="modelica://Modelica_DeviceDrivers/Resources/Include",
           Include = "#include \"MDDTCPIPSocket.h\" ",
           Library = {"pthread", "Ws2_32"},
           __iti_dll = "ITI_MDD.dll");
  end sendTo;

end TCPIPSocketClient_;
