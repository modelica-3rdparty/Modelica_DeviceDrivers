within Modelica_DeviceDrivers.Communication;
package UDPSocket_ "Accompanying functions for the UDPSocket object"
  extends Modelica_DeviceDrivers.Utilities.Icons.DriverIcon;
  encapsulated function read
    import Modelica_DeviceDrivers.Communication.UDPSocket;
    import Modelica_DeviceDrivers.Packaging.SerialPackager;
    input UDPSocket socket;
    input SerialPackager pkg;
    external "C" MDD_udpReadP(socket, pkg)
    annotation(Include = "#include \"MDDUDPSocket.h\"",
           Library = {"pthread", "Ws2_32"},
           __iti_dll = "ITI_MDD.dll",
           __iti_dllNoExport = true);
  end read;

  encapsulated function sendTo
    import Modelica_DeviceDrivers.Communication.UDPSocket;
    import Modelica_DeviceDrivers.Packaging.SerialPackager;
    input UDPSocket socket;
    input String ipAddress "IP address where data has to be sent";
    input Integer port "Port number where data has to be sent";
    input SerialPackager pkg;
    input Integer dataSize "Size of data";
    external "C" MDD_udpSendP(socket, ipAddress, port, pkg, dataSize)
    annotation(Include = "#include \"MDDUDPSocket.h\"",
           Library = {"pthread", "Ws2_32"},
           __iti_dll = "ITI_MDD.dll",
           __iti_dllNoExport = true);
  end sendTo;

  encapsulated function getReceivedBytes
    import Modelica_DeviceDrivers.Communication.UDPSocket;
    input UDPSocket socket;
    output Integer receivedBytes "number of Bytes received";
    external "C" receivedBytes =  MDD_udpGetReceivedBytes(socket)
    annotation(Include = "#include \"MDDUDPSocket.h\"",
           Library = {"pthread", "Ws2_32"},
           __iti_dll = "ITI_MDD.dll",
           __iti_dllNoExport = true);
  end getReceivedBytes;
end UDPSocket_;
