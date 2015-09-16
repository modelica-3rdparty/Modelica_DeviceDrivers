within Modelica_DeviceDrivers.InputDevices;
package GameController_ "Accompanying function for the GameController object"
  extends Modelica_DeviceDrivers.Utilities.Icons.DriverIcon;
  function getData "reads data from joystick"
    input Modelica_DeviceDrivers.InputDevices.GameController joystick;
    output Real Axes[6] "Axes values from -1 to 1";
    output Integer Buttons[32] "Buttons values";
    output Integer POV "angle of POV";
    external "C" MDD_joystickGetData(joystick, Axes, Buttons, POV)
      annotation(Include = "#include \"MDDJoystick.h\" ",
        Library = "Winmm",
        __iti_dll = "ITI_MDD.dll");
    annotation(__OpenModelica_Impure=true, __iti_Impure=true);
  end getData;
end GameController_;
