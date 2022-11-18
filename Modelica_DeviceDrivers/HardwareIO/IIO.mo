within Modelica_DeviceDrivers.HardwareIO;
class IIO
  "Interface to the Industrial I/O (http://analogdevicesinc.github.io/libiio/), a linux subsystem to communicate with ICs"
extends ExternalObject;

encapsulated function constructor "Open device"
  import Modelica;
  extends Modelica.Icons.Function;
  import Modelica_DeviceDrivers.HardwareIO.IIO;
  input String targetname "Network address of IIO device. Leave empty for local device (Linux only)";
  output IIO iio "File handle to IIO context";
  external "C" iio = MDD_iio_open(targetname)
  annotation (Include="#include \"MDDIIO.h\"", Library="libiio");
end constructor;

encapsulated function destructor "Close device"
  import Modelica;
  extends Modelica.Icons.Function;
  import Modelica_DeviceDrivers.HardwareIO.IIO;
  input IIO iio "File handle to IIO context";
  external "C" MDD_iio_close(iio)
  annotation (Include="#include \"MDDIIO.h\"", Library="libiio");
end destructor;

end IIO;
