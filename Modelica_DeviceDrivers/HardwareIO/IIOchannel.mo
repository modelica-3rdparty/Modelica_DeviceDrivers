within Modelica_DeviceDrivers.HardwareIO;
class IIOchannel
  "Interface to a Industrial I/O device channel"
extends ExternalObject;

encapsulated function constructor "Open channel"
  import Modelica;
  extends Modelica.Icons.Function;
  import Modelica_DeviceDrivers.HardwareIO.IIO;
  import Modelica_DeviceDrivers.HardwareIO.IIOchannel;
  input IIO iio "File handle to IIO context";
  input String devicename "Device name";
  input String channelname "Channel name";
  output IIOchannel channel "File handle to IIO channel";
  external "C" channel = MDD_iio_open_channel(iio, devicename, channelname)
  annotation (Include="#include \"MDDIIO.h\"", Library="libiio");
end constructor;

encapsulated function destructor "Close channel"
  import Modelica;
  extends Modelica.Icons.Function;
  import Modelica_DeviceDrivers.HardwareIO.IIOchannel;
  input IIOchannel channel "Channel context";
  external "C" MDD_iio_close_channel(channel)
  annotation (Include="#include \"MDDIIO.h\"", Library="libiio");
end destructor;

end IIOchannel;
