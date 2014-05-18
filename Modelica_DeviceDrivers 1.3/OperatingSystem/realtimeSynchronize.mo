within Modelica_DeviceDrivers.OperatingSystem;
function realtimeSynchronize
  "pauses the simulation until synchronisation with realtime is achieved"
input Real simTime;
input Integer resolution = 1
    "Only supported with Windows. Ignored if executing on Linux";
output Real calculationTime;
output Real availableTime;
external "C" calculationTime = MDD_realtimeSynchronize(simTime,resolution,availableTime)
annotation(IncludeDirectory="modelica://Modelica_DeviceDrivers/Resources/Include",
           Include = "#include \"MDDRealtimeSynchronize.h\" ",
           Library = "rt",
           __iti_dll = "ITI_MDD.dll");
end realtimeSynchronize;
