within Modelica_DeviceDrivers.Incubate.Blocks;
model UDPBlockingReceive
  "(2012-05-24: Not yet adapted for synchronous elements) A block for receiving UDP packets which blocks if no new data is available"

  extends Modelica_DeviceDrivers.Utilities.Icons.BaseIcon;
  extends Modelica_DeviceDrivers.Utilities.Icons.UDPconnection;
  extends Modelica.Icons.UnderConstruction;
  Modelica_DeviceDrivers.Obsolete.Blocks.Packaging.Internal.packageDataOutput
                                              packageDataOutput
                                                         annotation (Placement(
        transformation(
        extent={{-20,-20},{20,20}},
        rotation=90,
        origin={108,0})));

  parameter Real sampleTime=0.01 "Sample time for input update";
  parameter Integer bufferSize=16*1024 "Buffersize available for datagrams";
  parameter Boolean blockDuringFirstSample = false
    "If true, block on datagram receive during first sampling of block equations, otherwise skip blocking for first sampling";

  parameter Integer port_recv=10001
    "Listening port number of the Server. Must be unique on the system."
    annotation (Dialog(group="Incoming data"));

protected
  Integer socketID;
  Integer packagerID;
  Boolean newData;
  Boolean firstSample(start=true, fixed=true);
algorithm
  newData :=false;

  if firstSample and not blockDuringFirstSample then
    // If this is (before) first sampling of equations, don't block until new data is available
    // (unless parameter blockDuringFirstSample == true)
  else
     while not newData loop
       // loop and block until new data was received
       newData := Modelica_DeviceDrivers.Communication.UDPSocket.getRecievedBytes(socketID) > 0;
     end while;
  end if;
equation
  when (initial()) then

    packagerID =
      Modelica_DeviceDrivers.Obsolete.Communication.Packager.MinimalSerialPackager.constructMinimalSerialPackager(
       bufferSize);
    packageDataOutput.packagerID = packagerID;
    socketID = Modelica_DeviceDrivers.Communication.UDPSocket.createUDPSocket(port_recv,bufferSize);

  end when;
  packageDataOutput.trigger = sample(0,sampleTime);

  when (sample(0, sampleTime)) then
    Modelica_DeviceDrivers.Obsolete.Communication.Packager.MinimalSerialPackager.setPackage(
      packagerID, Modelica_DeviceDrivers.Communication.UDPSocket.read(socketID),
      bufferSize);
    firstSample = false; // after the first sampling of this when statement set firstSample to false
    packageDataOutput.dummy = time;
  end when;

  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics={Text(extent={{-150,136},{150,96}},
            textString="%name")}), Diagram(coordinateSystem(preserveAspectRatio=true,
                 extent={{-100,-100},{100,100}}), graphics));
end UDPBlockingReceive;
