within Modelica_DeviceDrivers.Communication;
package SerialPort_ "Accompanying functions for the SerialPort object"
  extends Modelica_DeviceDrivers.Utilities.Icons.DriverIcon;

  encapsulated function read
    import Modelica_DeviceDrivers.Communication.SerialPort;
    input SerialPort sPort;
    output String data;
  external "C" data=  MDD_serialPortRead(sPort)
  annotation(IncludeDirectory="modelica://Modelica_DeviceDrivers/Resources/Include",
             Include = "#include \"MDDSerialPort.h\" ");
  end read;

  encapsulated function sendTo
    import Modelica_DeviceDrivers.Communication.SerialPort;
    input SerialPort sPort "Serial Port object";
    input String data "Data to be sent";
    input Integer dataSize "Size of data";
  external "C" MDD_serialPortSend(sPort, data, dataSize)
  annotation(IncludeDirectory="modelica://Modelica_DeviceDrivers/Resources/Include",
             Include = "#include \"MDDSerialPort.h\" ");
  end sendTo;

  encapsulated function getReceivedBytes
    import Modelica_DeviceDrivers.Communication.SerialPort;
    input SerialPort sPort;
    output Integer receivedBytes "number of Bytes received";
    external "C" receivedBytes =
                                MDD_serialPortGetReceivedBytes(sPort)
    annotation(IncludeDirectory="modelica://Modelica_DeviceDrivers/Resources/Include",
             Include = "#include \"MDDSerialPort.h\" ");
  end getReceivedBytes;
end SerialPort_;
