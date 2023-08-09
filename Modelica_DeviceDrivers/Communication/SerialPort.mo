within Modelica_DeviceDrivers.Communication;
class SerialPort "A driver for serial port communication."
extends ExternalObject;
encapsulated function constructor
    "Creates a SerialPort instance with a given listening port."
  import Modelica;
  extends Modelica.Icons.Function;
  import Modelica_DeviceDrivers.Communication.SerialPort;
  import Modelica_DeviceDrivers.Utilities.Types.SerialBaudRate;
  input String deviceName "Serial port (/dev/ttyX or \\\\.\\COMX)";
  input Integer bufferSize=16*1024 "Size of receive buffer, may be set to 0 for sending serial port (receiver=0)";
  input Integer parity = 0 "0 - no parity, 1 - even, 2 - odd";
  input Integer receiver = 1 "0 - sender, 1 - receiver";
  input SerialBaudRate baud;
  input Integer byteSize = 8 "Number of data bits transmitted per (serial data format) byte (8 is most common)";
  output SerialPort sPort;
external "C" sPort = MDD_serialPortConstructor(deviceName, bufferSize, parity, receiver, baud, byteSize)
annotation(Include = "#include \"MDDSerialPort.h\"",
           Library = "pthread",
           __iti_dll = "ITI_MDD.dll",
           __iti_dllNoExport = true);
end constructor;

encapsulated function destructor
  import Modelica;
  extends Modelica.Icons.Function;
  import Modelica_DeviceDrivers.Communication.SerialPort;
  input SerialPort sPort;
external "C" MDD_serialPortDestructor(sPort)
annotation(Include = "#include \"MDDSerialPort.h\"",
           Library = "pthread",
           __iti_dll = "ITI_MDD.dll",
           __iti_dllNoExport = true);
end destructor;

end SerialPort;
