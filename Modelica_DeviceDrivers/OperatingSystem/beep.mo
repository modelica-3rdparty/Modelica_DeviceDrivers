within Modelica_DeviceDrivers.OperatingSystem;
function beep "it beeps."
import Modelica;
extends Modelica.Icons.Function;
input Real frequency;
input Real duration;
external "C" MDD_beep(frequency,duration)
annotation(Include = "#include \"MDDBeep.h\"",
           Library = "x11",
           __iti_dll = "ITI_MDD.dll",
           __iti_dllNoExport = true);
annotation(__ModelicaAssociation_Impure=true);
end beep;
