within Modelica_DeviceDrivers.Communication;
package SerialPort_ "Accompanying functions for the SerialPort object"
  extends Modelica_DeviceDrivers.Utilities.Icons.DriverIcon;

  encapsulated function read
    import Modelica;
    extends Modelica.Icons.Function;
    import Modelica_DeviceDrivers.Communication.SerialPort;
    import Modelica_DeviceDrivers.Packaging.SerialPackager;
    input SerialPort sPort;
    input SerialPackager pkg;
    external "C" MDD_serialPortReadP(sPort, pkg)
    annotation(Include = "#include \"MDDSerialPort.h\"",
             Library = "pthread",
           __iti_dll = "ITI_MDD.dll",
           __iti_dllNoExport = true);
  end read;

  encapsulated function sendTo
    import Modelica;
    extends Modelica.Icons.Function;
    import Modelica_DeviceDrivers.Communication.SerialPort;
    import Modelica_DeviceDrivers.Packaging.SerialPackager;
    input SerialPort sPort "Serial Port object";
    input SerialPackager pkg;
    input Integer dataSize "Size of data";
    external "C" MDD_serialPortSendP(sPort, pkg, dataSize)
    annotation(Include = "#include \"MDDSerialPort.h\"",
             Library = "pthread",
           __iti_dll = "ITI_MDD.dll",
           __iti_dllNoExport = true);
  end sendTo;

  encapsulated function getReceivedBytes "DEPRECATED. Get number of received bytes"
    import Modelica;
    extends Modelica.Icons.Function;
    extends Modelica.Icons.ObsoleteModel;
    import Modelica_DeviceDrivers.Communication.SerialPort;
    input SerialPort sPort;
    output Integer receivedBytes "Number of received bytes";
    external "C" receivedBytes = MDD_serialPortGetReceivedBytes(sPort)
    annotation(Include = "#include \"MDDSerialPort.h\"",
             Library = "pthread",
           __iti_dll = "ITI_MDD.dll",
           __iti_dllNoExport = true);
    annotation (Documentation(info="<html>
<p>Deprecated function. Don't use it.</p>
<p>
Kept for backward compatiblity. Only very limited use since due to thread parallism
(the serial port is read from a dedicated thread)
the returned value may already be outdated when it is returned or when a later
conditional action is based on the returned value.
</p>
</html>"));
  end getReceivedBytes;
end SerialPort_;
