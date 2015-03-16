within Modelica_DeviceDrivers.OperatingSystem;
class ProcessPriority "An object for process priority."
  extends ExternalObject;
  function constructor "Creates a ProcessPriority instance with a given process priority."
    output ProcessPriority procPrio;
    external "C" procPrio = MDD_ProcessPriorityConstructor()
      annotation(IncludeDirectory="modelica://Modelica_DeviceDrivers/Resources/Include",
        Include = "#include \"MDDRealtimeSynchronize.h\" ",
        Library = "rt",
        __iti_dll = "ITI_MDD.dll");
  end constructor;

  function destructor
    input ProcessPriority procPrio;
    external "C" MDD_ProcessPriorityDestructor(procPrio)
      annotation(IncludeDirectory="modelica://Modelica_DeviceDrivers/Resources/Include",
        Include = "#include \"MDDRealtimeSynchronize.h\" ",
        Library = "rt",
        __iti_dll = "ITI_MDD.dll");
  end destructor;
end ProcessPriority;
