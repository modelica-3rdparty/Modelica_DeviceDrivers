within Modelica_DeviceDrivers.OperatingSystem;
function clock "the time since OS startup in ms"
  input Real dummy;
  output Real clock "time in ms";
external "C" clock = MDD_getTimeMS(dummy)
annotation(Include = "#include \"MDDRealtimeSynchronize.h\" ",
           Library = "rt",
           __iti_dll = "ITI_MDD.dll",
           __iti_dllNoExport = true);
annotation(__ModelicaAssociation_Impure=true);
end clock;
