within Modelica_DeviceDrivers.Communication;
class SoftingCAN
  "BETA feature. Support for Softing's CAN interfaces utilizing their CANL2 API library"
extends ExternalObject;
encapsulated function constructor "Open Device"
    import Modelica_DeviceDrivers.Communication.SoftingCAN;
    import Modelica_DeviceDrivers.Utilities.Types;
    import Modelica_DeviceDrivers;
input String deviceName;
input Modelica_DeviceDrivers.Utilities.Types.BaudRate
                     baudRate;
output SoftingCAN softingCAN "Handle for device";

  external "C" softingCAN = MDD_softingCANConstructor(deviceName, baudRate)
  annotation (IncludeDirectory="modelica://Modelica_DeviceDrivers/Resources/Include",
    Include="#include \"MDDSoftingCAN.h\"",
              __iti_dll = "ITI_MDDSoftingCAN.dll");
end constructor;

encapsulated function destructor "Destroy object, free resources"
    import Modelica_DeviceDrivers.Communication.SoftingCAN;
  input SoftingCAN softingCAN "Handle for device";

  external "C" MDD_softingCANDestructor(softingCAN)
  annotation (IncludeDirectory="modelica://Modelica_DeviceDrivers/Resources/Include",
              Include="#include \"MDDSoftingCAN.h\"",
              __iti_dll = "ITI_MDDSoftingCAN.dll");
end destructor;

end SoftingCAN;
