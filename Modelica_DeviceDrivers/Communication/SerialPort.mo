within Modelica_DeviceDrivers.Communication;
class SerialPort "A driver for serial port communication."
extends ExternalObject;
encapsulated function constructor
    "Creates a SerialPort instance with a given listening port."
    import Modelica_DeviceDrivers.Communication.SerialPort;
  input String deviceName "Serial port (/dev/ttyX or \\\\.\\COMX")";
  input Integer bufferSize=16*1024 "Size of receive buffer";
  input Integer parity = 0 "0 - no parity, 1 - even, 2 - odd";
  input Integer receiver = 1 "0 - sender, 1 - receiver";
  input Integer baud = 0;
  output SerialPort sPort;
external "C" sPort = MDD_serialPortConstructor(deviceName, bufferSize, parity,receiver,baud)
annotation(IncludeDirectory="modelica://Modelica_DeviceDrivers/Resources/Include",
           Include = "#include \"MDDSerialPort.h\" ",
           __iti_dll = "ITI_MDD.dll");
end constructor;

encapsulated function destructor
    import Modelica_DeviceDrivers.Communication.SerialPort;
  input SerialPort sPort;
external "C" MDD_serialPortDestructor(sPort)
annotation(IncludeDirectory="modelica://Modelica_DeviceDrivers/Resources/Include",
           Include = "#include \"MDDSerialPort.h\" ",
           __iti_dll = "ITI_MDD.dll");
end destructor;

end SerialPort;
