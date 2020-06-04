within Modelica_DeviceDrivers.OperatingSystem;
class RTSync "An object for real-time synchronization."
  extends ExternalObject;
  function constructor "Creates a RTSync instance."
    extends Modelica.Icons.Function;
    input Modelica.Units.SI.Time startSimTime
      "Simulation start time (usually 0)";
    input Boolean shouldCatchupTime "true, try to catch up delays from missed dead-lines by progressing faster than real-time, otherwise do not";
    output RTSync rtSync;
    external "C" rtSync = MDD_RTSyncConstructor(startSimTime, shouldCatchupTime)
      annotation(Include = "#include \"MDDRealtimeSynchronize.h\"",
                 Library = {"rt", "Winmm"},
                 __iti_dll = "ITI_MDD.dll",
                 __iti_dllNoExport = true);
  end constructor;

  function destructor
    extends Modelica.Icons.Function;
    input RTSync rtSync;
    external "C" MDD_RTSyncDestructor(rtSync)
      annotation(Include = "#include \"MDDRealtimeSynchronize.h\"",
                 Library = {"rt", "Winmm"},
                 __iti_dll = "ITI_MDD.dll",
                 __iti_dllNoExport = true);
  end destructor;
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end RTSync;
