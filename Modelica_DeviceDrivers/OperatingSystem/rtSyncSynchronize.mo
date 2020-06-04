within Modelica_DeviceDrivers.OperatingSystem;
function rtSyncSynchronize "Slow down task so that simulation time == real-time."
  extends Modelica.Icons.Function;
  import      Modelica.Units.SI;
  input Modelica_DeviceDrivers.OperatingSystem.RTSync rtSync;
  input SI.Time simTime;
  input Real scaling(min=0) = 1 "Real-time scaling factor; > 1 means the simulation is made slower than real-time";
  output SI.Time wallClockTime "Wall clock time that elapsed since initialization of the real-time synchronization object";
  output SI.Time remainingTime "Wall clock time that is left before real-time deadline is reached.";
  output SI.Time computingTime "Wall clock time between invocations of this function, i.e., \"computing time\" in seconds";
  output SI.Time lastSimTime "Simulation time at the previous invocation of this function, the simulation start time at the first function invocation";
  external "C" MDD_RTSyncSynchronize(rtSync, simTime, scaling, wallClockTime, remainingTime, computingTime, lastSimTime)
  annotation(Include = "#include \"MDDRealtimeSynchronize.h\"",
           Library = {"rt", "Winmm"},
           __iti_dll = "ITI_MDD.dll",
           __iti_dllNoExport = true);
  annotation(__ModelicaAssociation_Impure=true);
end rtSyncSynchronize;
