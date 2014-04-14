within Modelica_DeviceDrivers.OperatingSystem;
function setProcessPriority
input Integer priority "Simulation process priority (-2(lowest)..2(realtime))";
external "C" MDD_setPriority(priority)
annotation(IncludeDirectory="modelica://Modelica_DeviceDrivers/Resources/Include",
           Include = "#include \"MDDRealtimeSynchronize.h\" ",
           Library = "rt",
           __iti_dll = "ITI_MDD.dll");
end setProcessPriority;
