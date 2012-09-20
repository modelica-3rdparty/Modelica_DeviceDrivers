within Modelica_DeviceDrivers.Incubate.Blocks;
package Internal

encapsulated function startChipDummy
    import Modelica_DeviceDrivers.Incubate.SoftingCAN;
  input SoftingCAN softingCAN "Handle for device";
  input Real dummy;
algorithm
  SoftingCAN.startChip(softingCAN);
end startChipDummy;

encapsulated function writeObjectDummy
    "Write object (CAN message) to transmit buffer"
    import Modelica_DeviceDrivers.Incubate.SoftingCAN;

  input SoftingCAN softingCAN "Handle for device";
  input Integer objectNumber "Object number of message (from defineObject(..))";
  input Integer dataLength "Length of message in bytes";
  input String data "The payload data";
  input Real dummy;
  output Real dummy2;
algorithm
  SoftingCAN.writeObject(softingCAN, objectNumber, dataLength, data);
  dummy2 := dummy;
end writeObjectDummy;
end Internal;
