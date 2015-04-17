within Modelica_DeviceDrivers.OperatingSystem;
class RealTimeSynchronization "An object for real-time synchronization."
  extends ExternalObject;
  function constructor "Creates a RealTimeSynchronization instance."
    output RealTimeSynchronization rtSync;
    external "C" rtSync=  MDD_realtimeSynchronizeConstructor()
      annotation(IncludeDirectory="modelica://Modelica_DeviceDrivers/Resources/Include",
        Include = "#include \"MDDRealtimeSynchronize.h\" ",
        Library = {"rt", "Winmm"},
        __iti_dll = "ITI_MDD.dll");
  end constructor;

  function destructor
    input RealTimeSynchronization rtSync;
    external "C" MDD_realtimeSynchronizeDestructor(rtSync)
      annotation(IncludeDirectory="modelica://Modelica_DeviceDrivers/Resources/Include",
        Include = "#include \"MDDRealtimeSynchronize.h\" ",
        Library = {"rt", "Winmm"},
        __iti_dll = "ITI_MDD.dll");
  end destructor;
end RealTimeSynchronization;
