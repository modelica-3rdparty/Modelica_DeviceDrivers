within Modelica_DeviceDrivers.OperatingSystem;
function realtimeSynchronize
  "pauses the simulation until synchronization with real-time is achieved"
  input Modelica_DeviceDrivers.OperatingSystem.RealTimeSynchronization rtSync;
  input Real simTime;
  output Real calculationTime;
  output Real availableTime;
  external "C" calculationTime = MDD_realtimeSynchronize(rtSync, simTime, availableTime)
  annotation(Include = "#include \"MDDRealtimeSynchronize.h\" ",
           Library = {"rt", "Winmm"},
           __iti_dll = "ITI_MDD.dll");
annotation(__OpenModelica_Impure=true, __iti_Impure=true);
end realtimeSynchronize;
