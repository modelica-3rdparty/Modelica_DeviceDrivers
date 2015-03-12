within Modelica_DeviceDrivers.InputDevices;
package GameController
  "A device driver accessing game controllers like joysticks, gamepads, etc."
extends Modelica_DeviceDrivers.Utilities.Icons.DriverIcon;
function getData "reads data from joystick ID"
input Integer joystickID = 0
      "ID number of the game controller (0 = first controller attached to the system)";
output Real Axes[6] "Axes values from -1 to 1";
output Integer Buttons[32] "Buttons values";
output Integer POV "angle of POV";
external "C" MDD_joystickGetData(joystickID,Axes, Buttons, POV)
annotation(IncludeDirectory="modelica://Modelica_DeviceDrivers/Resources/Include",
           Include = "#include \"MDDJoystick.h\" ",
           __iti_dll = "ITI_MDD.dll");
annotation(__OpenModelica_Impure=true, __iti_Impure=true);
end getData;
end GameController;
