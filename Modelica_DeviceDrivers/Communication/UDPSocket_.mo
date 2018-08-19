within Modelica_DeviceDrivers.Communication;
package UDPSocket_ "Accompanying functions for the UDPSocket object"
  extends Modelica_DeviceDrivers.Utilities.Icons.DriverIcon;
  encapsulated function read
    import Modelica;
    extends Modelica.Icons.Function;
    import Modelica_DeviceDrivers.Communication.UDPSocket;
    import Modelica_DeviceDrivers.Packaging.SerialPackager;
    input UDPSocket socket;
    input SerialPackager pkg;
    output Integer nReceivedBytes "Number of received bytes";
    output Integer nRecvbufOverwrites "Accumulated number of times new data was received without having been read out (retrieved) by Modelica";
    external "C" MDD_udpReadP(socket, pkg, nReceivedBytes, nRecvbufOverwrites)
    annotation(Include = "#include \"MDDUDPSocket.h\"",
           Library = {"pthread", "Ws2_32"},
           __iti_dll = "ITI_MDD.dll",
           __iti_dllNoExport = true);
  end read;

  encapsulated function sendTo
    import Modelica;
    extends Modelica.Icons.Function;
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

  encapsulated function getReceivedBytes "DEPRECATED. Get number of received bytes"
    import Modelica;
    extends Modelica.Icons.Function;
    extends Modelica.Icons.ObsoleteModel;
    import Modelica_DeviceDrivers.Communication.UDPSocket;
    input UDPSocket socket;
    output Integer receivedBytes "number of Bytes received";
    external "C" receivedBytes =  MDD_udpGetReceivedBytes(socket)
    annotation(Include = "#include \"MDDUDPSocket.h\"",
           Library = {"pthread", "Ws2_32"},
           __iti_dll = "ITI_MDD.dll",
           __iti_dllNoExport = true);
    annotation (Documentation(info="<html>
<p>Deprecated function. Don't use it.</p>
<p>
Kept for backward compatibility. Only very limited use since due to thread parallelism
(the listening UDP socket is run in a dedicated thread)
the returned value may already be outdated when it is returned or when a later
conditional action is based on the returned value.
</p>
</html>"));
  end getReceivedBytes;
end UDPSocket_;
