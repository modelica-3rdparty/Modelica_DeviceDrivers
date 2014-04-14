within Modelica_DeviceDrivers.OperatingSystem;
function beep "it beeps."
input Real frequency;
input Real duration;
external "C" MDD_beep(frequency,duration)
annotation(IncludeDirectory="modelica://Modelica_DeviceDrivers/Resources/Include",
           Include = "#include \"MDDBeep.h\" ",
           Library = "X11",
           __iti_dll = "ITI_MDD.dll");
end beep;
