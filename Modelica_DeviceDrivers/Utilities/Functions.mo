within Modelica_DeviceDrivers.Utilities;
package Functions
  extends Modelica.Icons.FunctionsPackage;
  function loadRealParameter "Loads a parameter from file"
    extends Modelica.Icons.Function;
    input String file="Washout.ini";
    input String name="K_Px";
    output Real u;

  external"C" u = MDD_utilitiesLoadRealParameter(file, name)
  annotation(Include = "#include \"MDDUtilities.h\"",
             __iti_dll = "ITI_MDD.dll",
             __iti_dllNoExport = true);
  annotation(Documentation(info="<html>
<h4>Load parameters from file during initialization</h4>
<p>The function expects a file format in the style <code>&quot;identifier=value&quot;</code>.</p>
<h4>Example</h4>
<p>Consider following example file and assume it's saved under location<br>
<code>&quot;modelica://Modelica_DeviceDrivers/Resources/test/Util/parameterInitValues.txt&quot;</code>:</p>
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
   Modelica.Utilities.Files.loadResource(\"modelica://Modelica_DeviceDrivers/Resources/test/Util/parameterInitValues.txt\"), \"var1\");
  parameter Integer n = 3 \"Size of arrayvar\";
  parameter Real arrayvar[n] = loadRealParameterVector(
   Modelica.Utilities.Files.loadResource(\"modelica://Modelica_DeviceDrivers/Resources/test/Util/parameterInitValues.txt\"), \"arrayvar\", n);
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
    extends Modelica.Icons.Function;
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

  function primeDecomposition "Decompose an integer into its prime factors"
    extends Modelica.Icons.Function;
    input Integer i;
    output Integer res[:];
  protected
    Integer number=i, div=2;
  algorithm
    assert(number >= 1, "Cannot decompose integer "+String(i)+" into prime factors");
    if number == 1 then
      res := {number};
      return;
    end if;
    res := fill(0, 0);
    while number <> 0 loop
      if (mod(number,div) <> 0) then
        div := div + 1;
      else
        number := .div(number, div);
        res := cat(1, res, {div});
        if number==1 then
          break;
        end if;
      end if;
    end while;
    annotation (Documentation(info="<html>
<p>Decomposes an integer into its prime factors.</p>
</html>"));
  end primeDecomposition;

  function generateUUID "Generate a UUID"
    extends Modelica.Icons.Function;
    output String uuid "UUID";

  external"C" uuid = MDD_utilitiesGenerateUUID()
  annotation(Include = "#include \"MDDUtilitiesUUID.h\"",
             Library = {"Rpcrt4", "uuid"},
             __iti_dll = "ITI_MDD.dll",
             __iti_dllNoExport = true);
  annotation(__ModelicaAssociation_Impure=true, Documentation(info="<html>
<p>Generates a UUID.</p>
</html>"));
  end generateUUID;

  function getMACAddress "Get a MAC address"
    extends Modelica.Icons.Function;
    input Integer i(min=1) = 1 "Index";
    output String mac "MAC address";

  external"C" mac = MDD_utilitiesGetMACAddress(i)
  annotation(Include = "#include \"MDDUtilitiesMAC.h\"",
             Library = {"IPHlpApi"},
             __iti_dll = "ITI_MDD.dll",
             __iti_dllNoExport = true);
  annotation(Documentation(info="<html>
<p>Gets the <code>i</code>-th MAC address.</p>
</html>"));
  end getMACAddress;
end Functions;
