within Modelica_DeviceDrivers.Incubate.Bustesting;
record CANSignal
  extends Modelica.Icons.Record;
  Integer dataType = 1;
  Integer bitStartPosition(min=0,max=63) = 0
    "(min=0,max=63) Bit start position in CAN data field (CAN data field length is 64 bit)";
  Integer integerWidth = 32 "Integer width on CAN bus";
end CANSignal;
