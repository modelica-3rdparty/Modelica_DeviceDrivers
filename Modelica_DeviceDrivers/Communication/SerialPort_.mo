within Modelica_DeviceDrivers.Communication;
package SerialPort_ "Accompanying functions for the SerialPort object"
  extends Modelica_DeviceDrivers.Utilities.Icons.DriverIcon;

  encapsulated function read
    import Modelica_DeviceDrivers.Communication.SerialPort;
    input SerialPort sPort;
    input Modelica_DeviceDrivers.Packaging.SerialPackager pkg "Data package to be read";
    external "C" MDD_serialPortReadP(sPort, pkg)
    annotation(IncludeDirectory="modelica://Modelica_DeviceDrivers/Resources/Include",
             Include = "#include \"MDDSerialPort.h\" ",
             Library = "pthread",
           __iti_dll = "ITI_MDD.dll");
  end read;

  encapsulated function sendTo
    import Modelica_DeviceDrivers.Communication.SerialPort;
    input SerialPort sPort "Serial Port object";
    input Modelica_DeviceDrivers.Packaging.SerialPackager pkg "Data package to be sent";
    input Integer dataSize "Size of data";
    external "C" MDD_serialPortSendP(sPort, pkg, dataSize)
    annotation(IncludeDirectory="modelica://Modelica_DeviceDrivers/Resources/Include",
             Include = "#include \"MDDSerialPort.h\" ",
             Library = "pthread",
           __iti_dll = "ITI_MDD.dll");
  end sendTo;

  encapsulated function getReceivedBytes
    import Modelica_DeviceDrivers.Communication.SerialPort;
    input SerialPort sPort;
    output Integer receivedBytes "number of Bytes received";
    external "C" receivedBytes = MDD_serialPortGetReceivedBytes(sPort)
    annotation(IncludeDirectory="modelica://Modelica_DeviceDrivers/Resources/Include",
             Include = "#include \"MDDSerialPort.h\" ",
             Library = "pthread",
           __iti_dll = "ITI_MDD.dll");
  end getReceivedBytes;
end SerialPort_;
