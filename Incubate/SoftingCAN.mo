within Modelica_DeviceDrivers.Incubate;
class SoftingCAN
  "Support for Softing's CAN interfaces utilzing their CANL2 API library"
extends Modelica_DeviceDrivers.Utilities.Icons.DriverIcon;
extends ExternalObject;
encapsulated function constructor "Open Device"
    import Modelica_DeviceDrivers.Incubate.SoftingCAN;
    import Modelica_DeviceDrivers.Incubate.Types;
input String deviceName;
input Types.BaudRate baudRate;
output SoftingCAN softingCAN "Handle for device";

  external "C" softingCAN = MDD_softingCANConstructor(deviceName, baudRate);
  annotation (IncludeDirectory="modelica://Modelica_DeviceDrivers/Resources/Include",
    Include="#include \"MDDSoftingCAN.h\"",
              Library={"canL2"});
end constructor;

encapsulated function destructor "Destroy object, free resources"
    import Modelica_DeviceDrivers.Incubate.SoftingCAN;
  input SoftingCAN softingCAN "Handle for device";

  external "C" MDD_softingCANDestructor(softingCAN);
  annotation (IncludeDirectory="modelica://Modelica_DeviceDrivers/Resources/Include",
              Include="#include \"MDDSoftingCAN.h\"",
              Library={"canL2"});
end destructor;

encapsulated function defineObject "Define available objects (CAN messages)"
    import Modelica_DeviceDrivers.Incubate.SoftingCAN;
    import Modelica_DeviceDrivers.Incubate.Types;
  input SoftingCAN softingCAN "Handle for device";
  input Integer ident "Identifier of CAN message (CAN Id)";
  input Types.TransmissionType transType
      "transmission type (receiving or sending)";
  output Integer objectNumber
      "Object number of message. Needed for further queries regarding receiving/transmitting the message";

  external "C" objectNumber = MDD_softingCANDefineObject(softingCAN, ident, transType);
  annotation (IncludeDirectory="modelica://Modelica_DeviceDrivers/Resources/Include",
              Include="#include \"MDDSoftingCAN.h\"",
              Library={"canL2"});
end defineObject;

encapsulated function startChip
    "Put CAN controllers of both CAN channels into operational mode (all object definitions have to be completed before!)"
    import Modelica_DeviceDrivers.Incubate.SoftingCAN;
  input SoftingCAN softingCAN "Handle for device";

  external "C" MDD_softingCANStartChip(softingCAN);
  annotation (IncludeDirectory="modelica://Modelica_DeviceDrivers/Resources/Include",
              Include="#include \"MDDSoftingCAN.h\"",
              Library={"canL2"});
end startChip;

encapsulated function writeObject
    "Write object (CAN message) to transmit buffer"
    import Modelica_DeviceDrivers.Incubate.SoftingCAN;

  input SoftingCAN softingCAN "Handle for device";
  input Integer objectNumber "Object number of message (from defineObject(..))";
  input Integer dataLength "Length of message in bytes";
  input String data "The payload data";

  external "C" MDD_softingCANWriteObject(softingCAN, objectNumber, dataLength, data);
  annotation (IncludeDirectory="modelica://Modelica_DeviceDrivers/Resources/Include",
              Include="#include \"MDDSoftingCAN.h\"",
              Library={"canL2"});
end writeObject;

encapsulated function readRcvData "Read data from object (CAN message)"
/*
    import Modelica_DeviceDrivers.Incubate.SoftingCAN;
    import Modelica_DeviceDrivers.Obsolete.Communication.Packager.CANMessage;

  input SoftingCAN softingCAN "Handle for device";
  input Integer objectNumber "Object number of message (from defineObject(..))";
  input String buffer "String which is capable to take at least 8 elements";
  output String data "Payload data";

  external "C" data = MDD_softingCANReadRcvData(softingCAN, objectNumber, buffer);
  annotation (IncludeDirectory="modelica://Modelica_DeviceDrivers/Resources/Include",
              Include="#include \"MDDSoftingCAN.h\"",
              Library={"canL2"});
*/
end readRcvData;

/*
encapsulated function readInteger "Read Integer from CAN bus"
    import Modelica_DeviceDrivers.Incubate.SoftingCAN;
  input CANL2 cANL2 "Handle for device";
  input Integer identifier "Identifier of CAN object/message";
  input Integer width(min=0, max=32) = 32 "Width of bits to be read";
  input Integer bitPosition(min=0,max=63) = 0 
      "Bit position start in CAN data field there data shall be read from";
  input Real simTime "simulation Time";

  output Integer data;

  external "C" data = mefiCANL2_readInteger(cANL2, identifier, width, bitPosition, simTime);
end readInteger;

encapsulated function writeInteger "Write Integer to CAN bus"
    import Modelica_DeviceDrivers.Incubate.SoftingCAN;
  input CANL2 cANL2 "Handle for device";
  input Integer identifier = 100 "Identifier of CAN object/message";
  input Integer width = 32 "Width of bits to be written";
  input Integer bitPosition(min=0,max=63) = 0 
      "Bit position start in CAN data field there data shall be written to";
  input Integer data;

  external "C" mefiCANL2_writeInteger(cANL2, identifier, width, bitPosition, data);
end writeInteger;
*/

end SoftingCAN;
