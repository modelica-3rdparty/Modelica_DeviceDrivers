within Modelica_DeviceDrivers.OperatingSystem;
function clock "the time since OS startup in ms"
  input Real dummy;
  output Real clock "time in ms";
external "C" clock = MDD_getTimeMS(dummy)
annotation(IncludeDirectory="modelica://Modelica_DeviceDrivers/Resources/Include",
           Include = "#include \"MDDRealtimeSynchronize.h\" ",
           Library = "rt",
           __iti_dll = "ITI_MDD.dll");
annotation(__OpenModelica_Impure=true, __iti_Impure=true);
end clock;
