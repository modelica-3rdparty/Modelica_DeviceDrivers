within Modelica_DeviceDrivers.Incubate.Blocks;
record CANConfigRecord "Configuration for Softing CAN interfaces"
  extends Modelica_DeviceDrivers.Incubate.Icons.BusIconRecord;
  import Modelica_DeviceDrivers.Incubate.Types.*;
  parameter String deviceName = "Softing2" "Name of CAN device";
  parameter BaudRate baudRate = BaudRate.kBaud1000 "Baud rate of device";

end CANConfigRecord;
