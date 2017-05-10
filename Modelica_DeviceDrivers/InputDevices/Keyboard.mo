within Modelica_DeviceDrivers.InputDevices;
package Keyboard "A driver accessing the keyboard."
extends Modelica_DeviceDrivers.Utilities.Icons.DriverIcon;
function getKey "reads data from a single key of the keyboard"
import Modelica;
extends Modelica.Icons.Function;
input Integer keyCode "Key code";
output Integer keyState "Key state";
external "C" MDD_keyboardGetKey(keyCode, keyState)
annotation(Include = "#include \"MDDKeyboard.h\"",
           Library = {"x11", "User32"},
           __iti_dll = "ITI_MDD.dll",
           __iti_dllNoExport = true);
annotation(__ModelicaAssociation_Impure=true);
end getKey;

function getData "reads data from several keyboard keys"
import Modelica;
extends Modelica.Icons.Function;
output Integer KeyCode[10] "Key values";
external "C" MDD_keyboardGetData(KeyCode)
annotation(Include = "#include \"MDDKeyboard.h\"",
           Library = {"x11", "User32"},
           __iti_dll = "ITI_MDD.dll",
           __iti_dllNoExport = true);
annotation(__ModelicaAssociation_Impure=true);
end getData;
end Keyboard;
