within Modelica_DeviceDrivers.Utilities;
package Functions
  extends Modelica.Icons.Package;
  function loadRealParameter "Loads a parameter from file"
    input String file="Washout.ini";
    input String name="K_Px";
    output Real u;

  external"C" u=  MDD_utilitiesLoadRealParameter(file, name)
  annotation(IncludeDirectory="modelica://Modelica_DeviceDrivers/Resources/Include",
             Include = "#include \"MDDUtilities.h\" ",
             __iti_dll = "ITI_MDD.dll");
  annotation(Documentation(info="<html>
<h4><font color=\"#008000\">Load parameters from file during initialization</font></h4>
<p>The function expects a file format in the style <code>&quot;identifier=value&quot;</code>.</p>
<h4><font color=\"#008000\">Example</font></h4>
<p>Consider following example file and assume it's saved under location<br/>
<code>Modelica_DeviceDrivers.Utilities.RootDir+&quot;/Resources/test/Util/parameterInitValues.txt&quot;</code>:</p>
<pre>
arrayvar_1=0.1
arrayvar_2=0.2
arrayvar_3=0.3
var1=13
</pre>
<p>Such a file could be accessed by the following Modelica code.</p>
<pre>
model TestLoadRealParameter
extends Modelica.Icons.Example;
  import Modelica_DeviceDrivers.Utilities.Functions.*;
  parameter Real var1 = loadRealParameter(
   Modelica_DeviceDrivers.Utilities.RootDir+\"/Resources/test/Util/parameterInitValues.txt\", \"var1\");
  parameter Integer n = 3 \"Size of arrayvar\";
  parameter Real arrayvar[n] = loadRealParameterVector(
   Modelica_DeviceDrivers.Utilities.RootDir+\"/Resources/test/Util/parameterInitValues.txt\", \"arrayvar\", n);
equation
  when sample(0, 0.1) then
    Modelica.Utilities.Streams.print(\"var1: \"+String(var1));
    for i in 1:3 loop
        Modelica.Utilities.Streams.print(\"arrayvar[\"+String(i)+\"] = \"+String(arrayvar[i]));
    end for;
  end when;
end TestLoadRealParameter;
</pre>
</html>"));

  end loadRealParameter;

  function loadRealParameterVector "Reads a parameter array from file"
    import readRealParameter =
      Modelica_DeviceDrivers.Utilities.Functions.loadRealParameter;
    input String file "name of configuration file";
    input String name "name of parameter";
    input Integer n "length of array";
    output Real u[n] "parameter array";
  algorithm
    for i in 1:n loop
      u[i] := readRealParameter(file, name + "_" + String(i));
    end for;

    annotation (Documentation(info="<html>
<p>Read a parameter array from file during initialization</p>
<p>See <a href=\"modelica://Modelica_DeviceDrivers.Utilities.Functions.loadRealParameter\"><code>loadRealParameter</code></a> for an example.</p>
</html>"));
  end loadRealParameterVector;
end Functions;
