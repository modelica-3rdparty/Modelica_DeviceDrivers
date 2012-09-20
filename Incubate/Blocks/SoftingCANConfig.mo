within Modelica_DeviceDrivers.Incubate.Blocks;
block SoftingCANConfig "Configuration for a softing CAN interface"
  extends Modelica_DeviceDrivers.Utilities.Icons.BaseIcon;
extends Modelica_DeviceDrivers.Incubate.Icons.BusIcon;
  import Modelica_DeviceDrivers.Incubate.Types.BaudRate;
  import Modelica_DeviceDrivers.Incubate.SoftingCAN;
parameter String deviceName = "CANusb_1" "Name of CAN device";
parameter Types.BaudRate baudRate = BaudRate.kBaud500 "CAN baud rate";
parameter Integer nu(min=0)=0 "Number of input connections"
    annotation(Dialog(connectorSizing=true), HideResult=true);

Interfaces.SoftingCANOut softingCANBus[nu]       annotation (Placement(
        transformation(
        extent={{-20,-20},{20,20}},
        rotation=90,
        origin={108,0})));

protected
  SoftingCAN softingCAN = SoftingCAN(deviceName, baudRate);
initial equation
  Modelica.Utilities.Streams.print("SoftingCAN ("+deviceName+"): Total number of defined messages: "+String(sum(softingCANBus.dummy))+".");
  Internal.startChipDummy(softingCAN, sum(softingCANBus.dummy));
equation
  softingCANBus.softingCAN = fill(softingCAN, nu);
  annotation (Icon(graphics={
        Text(
          extent={{-98,72},{94,46}},
          lineColor={0,0,0},
          textString="%deviceName")}),
                              Diagram(graphics));
end SoftingCANConfig;
