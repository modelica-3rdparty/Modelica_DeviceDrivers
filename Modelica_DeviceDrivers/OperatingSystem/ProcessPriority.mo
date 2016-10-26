within Modelica_DeviceDrivers.OperatingSystem;
class ProcessPriority "An object for process priority."
  extends ExternalObject;
  function constructor "Creates a ProcessPriority instance with a given process priority."
    import Modelica;
    extends Modelica.Icons.Function;
    output ProcessPriority procPrio;
    external "C" procPrio = MDD_ProcessPriorityConstructor()
      annotation(Include = "#include \"MDDRealtimeSynchronize.h\"",
                 Library = "rt",
                 __iti_dll = "ITI_MDD.dll",
                 __iti_dllNoExport = true);
  end constructor;

  function destructor
    import Modelica;
    extends Modelica.Icons.Function;
    input ProcessPriority procPrio;
    external "C" MDD_ProcessPriorityDestructor(procPrio)
      annotation(Include = "#include \"MDDRealtimeSynchronize.h\"",
                 Library = "rt",
                 __iti_dll = "ITI_MDD.dll",
                 __iti_dllNoExport = true);
  end destructor;
end ProcessPriority;
