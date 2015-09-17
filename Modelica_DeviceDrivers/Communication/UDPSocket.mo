within Modelica_DeviceDrivers.Communication;
class UDPSocket "A driver for UDP packet network communication."
extends ExternalObject;
encapsulated function constructor
    "Creates a UDPSocket instance with a given listening port."
    import Modelica_DeviceDrivers.Communication.UDPSocket;
  input Integer port "listening port";
  input Integer bufferSize=16*1024 "Size of receive buffer";
  output UDPSocket socket;
external "C" socket = MDD_udpConstructor(port,bufferSize)
annotation(Include = "#include \"MDDUDPSocket.h\" ",
           Library = {"pthread", "Ws2_32"},
           __iti_dll = "ITI_MDD.dll",
           __iti_dllNoExport = true);
end constructor;

encapsulated function destructor
    import Modelica_DeviceDrivers.Communication.UDPSocket;
  input UDPSocket socket;
external "C" MDD_udpDestructor(socket)
annotation(Include = "#include \"MDDUDPSocket.h\" ",
           Library = {"pthread", "Ws2_32"},
           __iti_dll = "ITI_MDD.dll",
           __iti_dllNoExport = true);
end destructor;

end UDPSocket;
