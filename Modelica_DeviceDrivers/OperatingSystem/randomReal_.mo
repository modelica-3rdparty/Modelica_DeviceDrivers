within Modelica_DeviceDrivers.OperatingSystem;
function randomReal_ "returns a random real within the given range."
  input Real minValue = 0;
  input Real maxValue = 1;
  output Real y;
  external "C" y = MDD_OS_getRandomNumberDouble(minValue, maxValue)
    annotation (Include = "#include \"MDDOperatingSystem.h\"",
                __iti_dll = "ITI_MDD.dll",
                __iti_dllNoExport = true);
  annotation(__ModelicaAssociation_Impure=true);
end randomReal_;
