within Modelica_DeviceDrivers.InputDevices;
package Keyboard "A driver accessing the keyboard."
extends Modelica_DeviceDrivers.Utilities.Icons.DriverIcon;
function getKey "reads data from a single key of the keyboard"
input Integer keyCode "Key code";
output Integer keyState "Key state";
external "C" MDD_keyboardGetKey(keyCode, keyState)
annotation(IncludeDirectory="modelica://Modelica_DeviceDrivers/Resources/Include",
           Include = "#include \"MDDKeyboard.h\" ",
           Library = "X11",
           __iti_dll = "ITI_MDD.dll");
end getKey;

function getData "reads data from several keyboard keys"
output Integer KeyCode[10] "Key values";
external "C" MDD_keyboardGetData(KeyCode)
annotation(IncludeDirectory="modelica://Modelica_DeviceDrivers/Resources/Include",
           Include = "#include \"MDDKeyboard.h\" ",
           Library = "X11",
           __iti_dll = "ITI_MDD.dll");
end getData;
end Keyboard;
