within Modelica_DeviceDrivers.Communication;
class SocketCAN
  "Support for the Linux Controller Area Network Protocol Family (aka Socket CAN)"
extends Modelica_DeviceDrivers.Utilities.Icons.DriverIcon;
extends ExternalObject;
encapsulated function constructor "Open Socket / Create external object"
    import Modelica_DeviceDrivers.Communication.SocketCAN;
input String ifr_name;
output SocketCAN softingCAN;

  external "C" softingCAN = MDD_socketCANConstructor(ifr_name);
  annotation (IncludeDirectory="modelica://Modelica_DeviceDrivers/Resources/Include",
    Include="#include \"MDDSocketCAN.h\"",
              Library={"MDDUtil"});
end constructor;

encapsulated function destructor "Destroy object, free resources"
import Modelica_DeviceDrivers.Communication.SocketCAN;
input SocketCAN socketCAN;

  external "C" MDD_socketCANDestructor(socketCAN);
  annotation (IncludeDirectory="modelica://Modelica_DeviceDrivers/Resources/Include",
              Include="#include \"MDDSocketCAN.h\"",
              Library={"MDDUtil"});
end destructor;

encapsulated function write "Write CAN frame/message to socket"
    import Modelica_DeviceDrivers.Communication.SocketCAN;

  input SocketCAN socketCAN;
  input Integer can_id "CAN frame identifier";
  input Integer can_dlc(min=0,max=8) " length of data in bytes (min=0, max=8)";
  input String data "The payload data";

  external "C" MDD_socketCANWrite(socketCAN, can_id, can_dlc, data);
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

  external "C" MDD_socketCANDefineObject(socketCAN, can_id, can_dlc);
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

external "C" data = MDD_socketCANRead(socketCAN, can_id, can_dlc, buffer);
annotation (IncludeDirectory="modelica://Modelica_DeviceDrivers/Resources/Include",
            Include="#include \"MDDSocketCAN.h\"",
            Library={"MDDUtil"});
end readObject;

end SocketCAN;
