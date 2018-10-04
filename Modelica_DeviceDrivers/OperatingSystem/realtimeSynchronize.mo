within Modelica_DeviceDrivers.OperatingSystem;
function realtimeSynchronize
  "pauses the simulation until synchronization with real-time is achieved"
  import Modelica;
  extends Modelica.Icons.Function;
  input Modelica_DeviceDrivers.OperatingSystem.RealTimeSynchronization rtSync;
  input Real simTime;
  input Boolean enableScaling = false "true, enable real-time scaling, else disable scaling";
  input Real scaling(min=0) = 1 "real-time scaling factor; > 1 means the simulation is made slower than real-time";
  output Real calculationTime;
  output Real availableTime;
  external "C" calculationTime = MDD_realtimeSynchronize(rtSync, simTime, enableScaling, scaling, availableTime)
  annotation(Include = "#include \"MDDRealtimeSynchronize.h\"",
           Library = {"rt", "Winmm"},
           __iti_dll = "ITI_MDD.dll",
           __iti_dllNoExport = true);
  annotation(__ModelicaAssociation_Impure=true);
end realtimeSynchronize;
