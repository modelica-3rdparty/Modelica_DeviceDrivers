within Modelica_DeviceDrivers.Utilities;
package Types "Custom type definitions"
  extends Modelica.Icons.Package;
  type SignalType = enumeration(
      integer "Integer value",
      float "IEEE float value",
      double "IEEE double value") "Encoded data type";
  type BaudRate = enumeration(
      kBaud1000 "1 Mega baud",
      kBaud800 "800 kilo baud",
      kBaud500 "500 kilo baud",
      kBaud250 "250 kilo baud",
      kBaud125 "125 kilo baud",
      kBaud100 "100 kilo baud",
      kBaud10 "10 kilo baud") "Baud rate of CAN device";
  type TransmissionType = enumeration(
      standardReceive "Standard receive object",
      standardTransmit "Standard transmit object",
      extendedReceive "Extended receive object",
      extendedTransmit "Extended transmit object")
    "Transmission type of CAN message";
  type SerialBaudRate = enumeration(
      B115200 "115.2k baud",
      B57600 "56k baud",
      B38400 "38.4k baud",
      B19200 "19.2k baud",
      B9600 "9600 baud",
      B4800 "4800 baud",
      B2400 "2400 baud") "Baud rate of serial device";
end Types;
