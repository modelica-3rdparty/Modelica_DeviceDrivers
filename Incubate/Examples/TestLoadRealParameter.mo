within Modelica_DeviceDrivers.Incubate.Examples;
model TestLoadRealParameter
extends Modelica.Icons.Example;
  parameter Real var1 = Modelica_DeviceDrivers.Incubate.Utilities.Functions.loadRealParameter(
   Modelica_DeviceDrivers.Utilities.RootDir+"/Resources/test/Util/parameterInitValues.txt", "var1");
  parameter Integer n = 3 "Size of arrayvar";
  parameter Real arrayvar[n] = Modelica_DeviceDrivers.Incubate.Utilities.Functions.loadRealParameterVector(
   Modelica_DeviceDrivers.Utilities.RootDir+"/Resources/test/Util/parameterInitValues.txt", "arrayvar", n);
equation
  when sample(0, 0.1) then
    Modelica.Utilities.Streams.print("var1: "+String(var1));
    for i in 1:3 loop
        Modelica.Utilities.Streams.print("arrayvar["+String(i)+"] = "+String(arrayvar[i]));
    end for;
  end when;
end TestLoadRealParameter;
