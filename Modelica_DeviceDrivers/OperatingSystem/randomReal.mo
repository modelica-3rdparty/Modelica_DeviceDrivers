within Modelica_DeviceDrivers.OperatingSystem;
function randomReal "returns a random real within the given range."
  import Modelica;
  extends Modelica.Icons.Function;
  input Real minValue = 0;
  input Real maxValue = 1;
  output Real y;
algorithm
    y := randomReal_(minValue, maxValue);
  annotation(__ModelicaAssociation_Impure=true, __iti_Inline=false,
    Documentation(info="<html><p>This wrapper function for the actual external function call <a href=\"modelica://Modelica_DeviceDrivers.OperatingSystem.randomReal_\">randomReal_</a> is required by SimulationX to force repeated function calls of <a href=\"modelica://Modelica_DeviceDrivers.Blocks.OperatingSystem.RandomRealSource\">Modelica_DeviceDrivers.Blocks.OperatingSystem.RandomRealSource</a> in case of n > 1.</p></html>"));
end randomReal;
