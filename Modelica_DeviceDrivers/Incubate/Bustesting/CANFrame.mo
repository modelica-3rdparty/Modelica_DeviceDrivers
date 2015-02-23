within Modelica_DeviceDrivers.Incubate.Bustesting;
record CANFrame "Record describing content of a CAN frame"
  extends Modelica.Icons.Record;
  parameter Integer nSignals=3;
  parameter Integer identifier = 100 "Identifier of CAN object/message";
  parameter CANSignal Signal[:];
end CANFrame;
