within Modelica_DeviceDrivers.OperatingSystem;
function randomReal_ "returns a random real within the given range."
  input Real minValue = 0;
  input Real maxValue = 1;
  output Real y;
  external "C" y = MDD_OS_getRandomNumberDouble(minValue, maxValue)
    annotation (Include = "#include \"MDDOperatingSystem.h\"",
                __iti_dll = "ITI_MDD.dll");
  annotation(__OpenModelica_Impure=true, __iti_Impure=true);
end randomReal_;
