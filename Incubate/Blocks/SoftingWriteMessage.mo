within Modelica_DeviceDrivers.Incubate.Blocks;
block SoftingWriteMessage
  import Modelica_DeviceDrivers;
  extends Modelica_DeviceDrivers.Incubate.Interfaces.PartialSoftingCANMessage;
  import Modelica_DeviceDrivers.Incubate.SoftingCAN;
  import Modelica_DeviceDrivers.Packaging.SerialPackager;
  import Modelica_DeviceDrivers.Incubate.Types;
  import SI = Modelica.SIunits;
parameter Integer ident(min=0) "Identifier of CAN message (CAN Id)";
parameter Integer dlc(min=0,max=8) = 8
    "Data length code (payload of data in bytes, max=8)";
parameter SI.Period sampleTime = 0.1 "Sample period of component";
parameter SI.Time startTime = 0 "First sample time instant";
  Modelica_DeviceDrivers.Blocks.Interfaces.PackageIn pkgIn
    annotation (Placement(transformation(extent={{-20,-128},{20,-88}})));
protected
  Integer objectNumber;
  Real dummy;
initial equation
  objectNumber =  SoftingCAN.defineObject(
    softingCANBus.softingCAN,
    ident,
    Types.TransmissionType.standardTransmit);
  softingCANBus.dummy = 1;
equation
  when initial() then
    pkgIn.userPkgBitSize = dlc*8;
    pkgIn.autoPkgBitSize = 0;
  end when;

  pkgIn.backwardTrigger = sample(startTime, sampleTime);
  when pkgIn.trigger then
    objectNumber = pre(objectNumber);
    dummy = Modelica_DeviceDrivers.Incubate.Blocks.Internal.writeObjectDummy(
      softingCANBus.softingCAN,
      objectNumber,
      dlc,
      SerialPackager.getPackage(pkgIn.pkg),
      pkgIn.dummy);

    softingCANBus.dummy = pre(softingCANBus.dummy);
  end when;
  annotation (defaultComponentName="txMessage",
  Icon(graphics={
        Text(
          extent={{-90,54},{96,24}},
          lineColor={0,0,0},
          textString="Tx id: %ident"),
        Text(
          extent={{-160,24},{160,-6}},
          lineColor={0,0,0},
          textString="(%startTime, %sampleTime) s")}),
    Diagram(graphics));
end SoftingWriteMessage;
