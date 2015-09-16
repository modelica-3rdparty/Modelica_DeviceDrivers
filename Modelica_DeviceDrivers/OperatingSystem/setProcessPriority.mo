within Modelica_DeviceDrivers.OperatingSystem;
function setProcessPriority
input Modelica_DeviceDrivers.OperatingSystem.ProcessPriority procPrio;
input Integer priority "Simulation process priority (-2(lowest)..2(realtime))";
external "C" MDD_setPriority(procPrio, priority)
annotation(Include = "#include \"MDDRealtimeSynchronize.h\" ",
           Library = {"rt", "Winmm"},
           __iti_dll = "ITI_MDD.dll");
annotation(__OpenModelica_Impure=true, __iti_Impure=true);
end setProcessPriority;
