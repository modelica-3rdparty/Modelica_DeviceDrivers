within Modelica_DeviceDrivers.OperatingSystem;
function sleep
 input Real sleepingTime
    "time (in seconds) during the simulation does nothing.";
external "C" MDD_OS_Sleep(sleepingTime)
 annotation(Include = "#include \"MDDOperatingSystem.h\"",
            __iti_dll = "ITI_MDD.dll");
end sleep;
