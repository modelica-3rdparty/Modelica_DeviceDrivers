within Modelica_DeviceDrivers.InputDevices;
class GameController "An object for game controller."
  extends ExternalObject;
  function constructor
    "Creates a GameController instance for a given ID number."
    input Integer joystickID = 0
      "ID number of the game controller (0 = first controller attached to the system)";
    output GameController gameCtrl;
    external "C" gameCtrl=  MDD_joystickConstructor(joystickID)
      annotation(Include = "#include \"MDDJoystick.h\" ",
        Library = "Winmm",
        __iti_dll = "ITI_MDD.dll");
  end constructor;

  function destructor
    input GameController gameCtrl;
    external "C" MDD_joystickDestructor(gameCtrl)
      annotation(Include = "#include \"MDDJoystick.h\" ",
        Library = "Winmm",
        __iti_dll = "ITI_MDD.dll");
  end destructor;
end GameController;
