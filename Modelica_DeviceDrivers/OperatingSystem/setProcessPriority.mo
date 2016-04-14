within Modelica_DeviceDrivers.OperatingSystem;
function setProcessPriority
input Modelica_DeviceDrivers.OperatingSystem.ProcessPriority procPrio;
input Integer priority "Simulation process priority (-2(lowest)..2(realtime))";
external "C" MDD_setPriority(procPrio, priority)
annotation(Include = "#include \"MDDRealtimeSynchronize.h\"",
           Library = {"rt", "Winmm"},
           __iti_dll = "ITI_MDD.dll",
           __iti_dllNoExport = true);
annotation(__ModelicaAssociation_Impure=true);
end setProcessPriority;
