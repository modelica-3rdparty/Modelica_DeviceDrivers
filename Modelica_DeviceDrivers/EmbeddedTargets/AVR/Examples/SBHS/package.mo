within Modelica_DeviceDrivers.EmbeddedTargets.AVR.Examples;
package SBHS
  extends .Modelica.Icons.ExamplesPackage;

  annotation(Documentation(info = "<html>
<h1>SBHS</h1>
<p>This is an example package of modeling a controller for the <a href=\"http://sbhs.fossee.in/\">Single Board Heater System (SBHS)</a> system using the Modelica_DeviceDrivers AVR package.</p>
<p>SBHS is a lab-in-a-box setup useful for teaching and learning control systems. It consists of a heater assembly, fan, temperature sensor, ATmega16 micro-controller and associated circuitry. A stainless steel blade whose temperature has to be controlled serves as the plant. Nichrome helical coil with 20 turns kept at a small distance from the steel blade, acts as the heater element. AD590, a monolithic integrated circuit temperature transducer, is soldered beneath the steel plate. A computer fan, a low cost and commercially of the shelf component, is used to cool the plate from below.</p>
</html>"));
end SBHS;