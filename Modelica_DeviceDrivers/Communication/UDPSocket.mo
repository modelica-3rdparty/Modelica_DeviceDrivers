within Modelica_DeviceDrivers.Communication;
class UDPSocket "A driver for UDP network communication."
extends ExternalObject;
encapsulated function constructor
    "Creates a UDPSocket instance with a given listening port."
  import Modelica;
  extends Modelica.Icons.Function;
  import Modelica_DeviceDrivers.Communication.UDPSocket;
  input Integer port "0 if a sending socket, otherwise the number of the listening port";
  input Integer bufferSize=16*1024 "Size of receive buffer, can be safely set to 0 for a sending socket";
  input Boolean useRecvThread=true "true, dedicated receiving thread writes datagrams into shared buffer";
  output UDPSocket socket;
external "C" socket = MDD_udpConstructor(port,bufferSize,useRecvThread)
annotation(Include = "#include \"MDDUDPSocket.h\"",
           Library = {"pthread", "Ws2_32"},
           __iti_dll = "ITI_MDD.dll",
           __iti_dllNoExport = true);
end constructor;

encapsulated function destructor
  import Modelica;
  extends Modelica.Icons.Function;
  import Modelica_DeviceDrivers.Communication.UDPSocket;
  input UDPSocket socket;
external "C" MDD_udpDestructor(socket)
annotation(Include = "#include \"MDDUDPSocket.h\"",
           Library = {"pthread", "Ws2_32"},
           __iti_dll = "ITI_MDD.dll",
           __iti_dllNoExport = true);
end destructor;

end UDPSocket;
