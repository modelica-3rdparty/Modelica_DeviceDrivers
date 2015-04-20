within Modelica_DeviceDrivers.Communication;
class TCPIPSocketClient "A client for TCP/IP packet network communication."
extends ExternalObject;
  encapsulated function constructor
    "Creates a TCP/IP socket client."
    import Modelica_DeviceDrivers.Communication.TCPIPSocketClient;
    input String ip "IP address";
    input Integer port "listening port";
    output TCPIPSocketClient socketClient;
  external "C" socketClient = MDD_TCPIPClient_Constructor(ip, port)
  annotation(IncludeDirectory="modelica://Modelica_DeviceDrivers/Resources/Include",
           Include = "#include \"MDDTCPIPSocket.h\" ",
           Library = {"pthread", "Ws2_32"},
           __iti_dll = "ITI_MDD.dll");
end constructor;

encapsulated function destructor
  "Closes a TCP/IP socket client."
  import Modelica_DeviceDrivers.Communication.TCPIPSocketClient;
  input TCPIPSocketClient socketClient;
  external "C" MDD_TCPIPClient_Destructor(socketClient)
  annotation(IncludeDirectory="modelica://Modelica_DeviceDrivers/Resources/Include",
           Include = "#include \"MDDTCPIPSocket.h\" ",
           Library = {"pthread", "Ws2_32"},
           __iti_dll = "ITI_MDD.dll");
end destructor;

end TCPIPSocketClient;
