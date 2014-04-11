within Modelica_DeviceDrivers.Communication;
package SocketCAN_ "Accompanying functions for the SocketCAN object"
  extends Modelica_DeviceDrivers.Utilities.Icons.DriverIcon;
encapsulated function write "Write CAN frame/message to socket"
    import Modelica_DeviceDrivers.Communication.SocketCAN;

  input SocketCAN socketCAN;
  input Integer can_id "CAN frame identifier";
  input Integer can_dlc(min=0,max=8) " length of data in bytes (min=0, max=8)";
  input String data "The payload data";

  external "C" MDD_socketCANWrite(socketCAN, can_id, can_dlc, data)
  annotation (IncludeDirectory="modelica://Modelica_DeviceDrivers/Resources/Include",
              Include="#include \"MDDSocketCAN.h\"",
              Library={"MDDUtil"});
end write;

encapsulated function defineObject
    "Define key/value pair for map associating identifiers to frame payload data."
    import Modelica_DeviceDrivers.Communication.SocketCAN;
  input SocketCAN socketCAN;
  input Integer can_id "CAN frame identifier";
  input Integer can_dlc(min=0,max=8) " length of data in bytes (min=0, max=8)";

  external "C" MDD_socketCANDefineObject(socketCAN, can_id, can_dlc)
  annotation (IncludeDirectory="modelica://Modelica_DeviceDrivers/Resources/Include",
              Include="#include \"MDDSocketCAN.h\"",
              Library={"MDDUtil"});
end defineObject;

encapsulated function readObject
    "Read previously defined CAN object from CAN interface."
    import Modelica_DeviceDrivers.Communication.SocketCAN;

  input SocketCAN socketCAN;
  input Integer can_id "CAN frame identifier";
  input Integer can_dlc(min=0,max=8) " length of data in bytes (min=0, max=8)";
  input String buffer
      "String which is capable to take at least can_dlc elements";
  output String data "Payload data";

external "C" data = MDD_socketCANRead(socketCAN, can_id, can_dlc, buffer)
annotation (IncludeDirectory="modelica://Modelica_DeviceDrivers/Resources/Include",
            Include="#include \"MDDSocketCAN.h\"",
            Library={"MDDUtil"});
end readObject;
end SocketCAN_;
