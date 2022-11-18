within Modelica_DeviceDrivers.HardwareIO.IIO_;
encapsulated function data_read "Read from analog channel"
  import Modelica;
  extends Modelica.Icons.Function;
  import Modelica_DeviceDrivers.HardwareIO.IIO;
  input IIO iio "Device handle";
  input String devicename = "/dev/comedi0" "Device name";
  input String channelname = "/dev/comedi0" "Device name";
  input String attrname = "/dev/comedi0" "Device name";
  output Real data "Value that is read from channel";
  external "C" data = MDD_iio_data_read(iio, devicename, channelname, attrname)
  annotation (Include="#include \"MDDIIO.h\"", Library="libiio");
end data_read;
