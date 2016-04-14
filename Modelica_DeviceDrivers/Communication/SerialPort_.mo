within Modelica_DeviceDrivers.Communication;
package SerialPort_ "Accompanying functions for the SerialPort object"
  extends Modelica_DeviceDrivers.Utilities.Icons.DriverIcon;

  encapsulated function read
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

  encapsulated function getReceivedBytes
    import Modelica_DeviceDrivers.Communication.SerialPort;
    input SerialPort sPort;
    output Integer receivedBytes "number of Bytes received";
    external "C" receivedBytes = MDD_serialPortGetReceivedBytes(sPort)
    annotation(Include = "#include \"MDDSerialPort.h\"",
             Library = "pthread",
           __iti_dll = "ITI_MDD.dll",
           __iti_dllNoExport = true);
  end getReceivedBytes;
end SerialPort_;
