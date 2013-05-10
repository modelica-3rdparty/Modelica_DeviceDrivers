within Modelica_DeviceDrivers.Communication;
package UDPSocket_ "Accompanying functions for the UDPSocket object"
  extends Modelica_DeviceDrivers.Utilities.Icons.DriverIcon;
encapsulated function read
    import Modelica_DeviceDrivers.Communication.UDPSocket;
  input UDPSocket socket;
output String data;
external "C" data = MDD_udpRead(socket);
annotation(IncludeDirectory="modelica://Modelica_DeviceDrivers/Resources/Include",
           Include = "#include \"MDDUDPSocket.h\" ");
end read;

encapsulated function sendTo
    import Modelica_DeviceDrivers.Communication.UDPSocket;
  input UDPSocket socket;
  input String ipAddress "IP address where data has to be sent";
  input Integer port "Port number where data has to be sent";
  input String data "Data to be sent";
  input Integer dataSize "Size of data";
external "C" MDD_udpSend(socket, ipAddress, port, data, dataSize);
annotation(IncludeDirectory="modelica://Modelica_DeviceDrivers/Resources/Include",
           Include = "#include \"MDDUDPSocket.h\" ");
end sendTo;

encapsulated function getRecievedBytes
    import Modelica_DeviceDrivers.Communication.UDPSocket;
  input UDPSocket socket;
  output Integer receivedBytes "number of Bytes recieved";
  external "C" receivedBytes =  MDD_udpGetRecievedBytes(socket);
  annotation(IncludeDirectory="modelica://Modelica_DeviceDrivers/Resources/Include",
           Include = "#include \"MDDUDPSocket.h\" ");
end getRecievedBytes;
end UDPSocket_;
