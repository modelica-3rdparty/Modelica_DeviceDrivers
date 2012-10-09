within Modelica_DeviceDrivers.Incubate.Blocks;
block SoftingReadMessage
  import Modelica_DeviceDrivers;

extends Modelica_DeviceDrivers.Incubate.Interfaces.PartialSoftingCANMessage;
  import Modelica_DeviceDrivers.Incubate.SoftingCAN;
  import Modelica_DeviceDrivers.Incubate.Types;
  import Modelica_DeviceDrivers.Packaging.SerialPackager;
  import SI = Modelica.SIunits;
parameter Integer ident(min=0) "Identifier of CAN message (CAN Id)";
parameter SI.Period sampleTime = 0.1 "Period at which messages are written";
parameter SI.Time startTime = 0 "First sample time instant";
  Modelica_DeviceDrivers.Blocks.Interfaces.PackageOut pkgOut
    annotation (Placement(transformation(extent={{-20,-128},{20,-88}})));
protected
  Integer objectNumber;
  Modelica_DeviceDrivers.Packaging.SerialPackager
                 pkg = SerialPackager(8);
initial equation
  objectNumber = SoftingCAN.defineObject(
    softingCANBus.softingCAN,
    ident,
    Types.TransmissionType.standardReceive);
  softingCANBus.dummy = 1;
equation
  pkgOut.trigger = sample(startTime, sampleTime);
  when pkgOut.trigger then
    objectNumber = pre(objectNumber);
    pkgOut.dummy = Modelica_DeviceDrivers.Blocks.Packaging.SerialPackager.Internal.DummyFunctions.setPackage(
    pkgOut.pkg,
    SoftingCAN.readRcvData(
      softingCANBus.softingCAN,
      objectNumber,
      SerialPackager.getPackage(pkgOut.pkg)),
      8,
      time);

    softingCANBus.dummy = pre(softingCANBus.dummy);
  end when;

  pkgOut.pkg = pkg;
  annotation (defaultComponentName="rxMessage",
  Icon(graphics={Text(
          extent={{-98,54},{98,26}},
          lineColor={0,0,0},
          textString="Rx id: %ident"),
        Text(
          extent={{-160,24},{160,-6}},
          lineColor={0,0,0},
          textString="(%startTime, %sampleTime) s")}),
    Diagram(graphics));
end SoftingReadMessage;
