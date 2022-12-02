within Modelica_DeviceDrivers.HardwareIO.IIO_;
encapsulated function data_read "Read from analog channel"
  import Modelica;
  extends Modelica.Icons.Function;
  import Modelica_DeviceDrivers.HardwareIO.IIO;
  import Modelica_DeviceDrivers.HardwareIO.IIOchannel;
  input IIOchannel channel "Channel handle";
  input String attrname "Device name";
  output Real data "Value that is read from channel";
  external "C" data = MDD_iio_data_read(channel, attrname)
  annotation (Include="#include \"MDDIIO.h\"", Library="libiio");
end data_read;
