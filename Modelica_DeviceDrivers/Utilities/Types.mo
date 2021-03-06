within Modelica_DeviceDrivers.Utilities;
package Types "Custom type definitions"
  extends Modelica.Icons.TypesPackage;
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
  type ByteOrder = enumeration(
      LE "Little endian",
      BE "Big endian") "Byte order";
  type LCMProvider = enumeration(
      UDPM "UDP multicast",
      FILE "Logfile") "LCM provider";
  type MQTTProvider = enumeration(
      TCP "TCP",
      SSL "Secure TLS encrypted TCP",
      WS "Websocket",
      WSS "Secure TLS encrypted websocket") "MQTT provider";
  type MQTTVersion = enumeration(
      DEFAULT "Try MQTT v3.1.1 then fall back to MQTT v3.1",
      V31 "MQTT v3.1",
      V311 "MQTT v3.1.1",
      V5 "MQTT v5.0") "MQTT version";
  type MQTTTracing = enumeration(
      DEFAULT "None",
      MAXIMUM "Maximum",
      MEDIUM "Medium",
      MINIMUM "Minimum",
      PROTOCOL "Protocol",
      ERROR "Error",
      SEVERE "Severe",
      FATAL "Fatal") "MQTT client tracing";
  type TLSVersion = enumeration(
      DEFAULT "SSL v2 / SSL v3",
      V10 "TLS v1.0",
      V11 "TLS v1.1",
      V12 "TLS v1.2") "SSL/TLS version";
end Types;
