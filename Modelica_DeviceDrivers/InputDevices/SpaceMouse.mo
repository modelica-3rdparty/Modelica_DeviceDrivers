within Modelica_DeviceDrivers.InputDevices;
package SpaceMouse "A driver accessing the 3DConnexion SpaceMouse."
extends Modelica_DeviceDrivers.Utilities.Icons.DriverIcon;
function getData "reads data from 3dConnexion SpaceMouse"
import Modelica;
extends Modelica.Icons.Function;
output Real Axes[6] "Axes values";
output Integer Buttons[16] "Buttons values";
external "C" MDD_spaceMouseGetData(Axes, Buttons)
annotation(Include = "#include \"MDDSpaceMouse.h\"",
           Library = {"MDDSpaceMouse", "x11"});
annotation(__ModelicaAssociation_Impure=true);
end getData;
end SpaceMouse;
