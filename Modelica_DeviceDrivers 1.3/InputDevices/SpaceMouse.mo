within Modelica_DeviceDrivers.InputDevices;
package SpaceMouse "A driver accessing the 3DConnexion SpaceMouse."
extends Modelica_DeviceDrivers.Utilities.Icons.DriverIcon;
function getData "reads data from 3dConnexion SpaceMouse"
output Real Axes[6] "Axes values";
output Integer Buttons[16] "Buttons values";
external "C" MDD_spaceMouseGetData(Axes, Buttons)
annotation(IncludeDirectory="modelica://Modelica_DeviceDrivers/Resources/Include",
           Include = "#include \"MDDSpaceMouse.h\" ",
           Library = {"MDDSpaceMouse", "X11"});
end getData;
end SpaceMouse;
