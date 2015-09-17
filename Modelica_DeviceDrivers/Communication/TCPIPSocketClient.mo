within Modelica_DeviceDrivers.Communication;
class TCPIPSocketClient "A client for TCP/IP packet network communication."
extends ExternalObject;
  encapsulated function constructor
    "Creates a TCP/IP socket client instance."
    import Modelica_DeviceDrivers.Communication.TCPIPSocketClient;
    output TCPIPSocketClient socketClient;
  external "C" socketClient = MDD_TCPIPClient_Constructor()
  annotation(Include = "#include \"MDDTCPIPSocket.h\" ",
           Library = {"pthread", "Ws2_32"},
           __iti_dll = "ITI_MDD.dll",
           __iti_dllNoExport = true);
end constructor;

encapsulated function destructor
  "Closes a TCP/IP socket client."
  import Modelica_DeviceDrivers.Communication.TCPIPSocketClient;
  input TCPIPSocketClient socketClient;
  external "C" MDD_TCPIPClient_Destructor(socketClient)
  annotation(Include = "#include \"MDDTCPIPSocket.h\" ",
           Library = {"pthread", "Ws2_32"},
           __iti_dll = "ITI_MDD.dll",
           __iti_dllNoExport = true);
end destructor;

end TCPIPSocketClient;
