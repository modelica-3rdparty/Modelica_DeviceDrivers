within Modelica_DeviceDrivers.OperatingSystem;
function clock "the time since OS startup in ms"
  input Integer resolution = 1 "resultion of timer in ms";
  output Real clock "time in ms";
external "C" clock = MDD_getTimeMS(resolution)
annotation(IncludeDirectory="modelica://Modelica_DeviceDrivers/Resources/Include",
           Include = "#include \"MDDRealtimeSynchronize.h\" ",
           Library = "rt",
           __iti_dll = "ITI_MDD.dll");
end clock;
